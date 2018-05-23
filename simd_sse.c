#include "support.h"
#include <xmmintrin.h> /* SSE intrinsics */

int main(void) {
    float ALG16 *inputframeA, *inputframeB, *outputframe;
    int i;

    get_aligned_memory ((void **) &inputframeA, IMAGE_BYTES);
    get_aligned_memory ((void **) &inputframeB, IMAGE_BYTES);
    get_aligned_memory ((void **) &outputframe, IMAGE_BYTES);

    init_devil();


#if 1
    /* Aufgabe 1: 2s schwarz */
    black_image (outputframe);
    save_for_seconds (outputframe, 2);
#endif

#if 1
    /* Aufgabe 2: fade in videoA over 2s */
    int frame;
    float fade_duration = 2 * 25.0; /* 2s */
    
    /* 
        HINWEISE
        
        Mit 'inputframeA', 'inputframeB' und 'outputframe' ist bereits Speicher allokiert, 
        der jeweils die Größe eines Bildes besitzt.
        Verwenden Sie diese Speicherbereiche als Zwischenspeicher um
        Bilder zu laden bzw. die Ergebnisse darin zwischenzuspeichern.        
    */
    
    for (frame = 0; frame < (int) fade_duration; frame++)
    {
        __m128 skalar;

        load_next_frame_from_videoA (inputframeA);
        skalar = _mm_set1_ps (((float) frame) / fade_duration);

        for (i=0; i < IMAGE_SIZE * 4; i+=4)
        {
            __m128 floatvektor, ergebnis;
            /* 1. Lade 4 floats in 'floatvektor' */
            floatvektor = _mm_load_ps (&inputframeA[i]);
            /* 2. Multipliziere 'floatvektor' mit 'skalar' und speicher in 'ergebnis'*/
            ergebnis = _mm_mul_ps (skalar, floatvektor);
            /* 3. Speichere 'ergebnis' is outputframe*/
            _mm_store_ps (&outputframe[i], ergebnis);
        }
        
        save_frame (outputframe);
    }

#endif

#if 1
    /* Aufgabe 3: display videoA for 2s */
    fade_duration = 2.0 * 25.0;
    
    for (frame = 0; frame < (int) fade_duration; frame++) {
        load_next_frame_from_videoA (inputframeA);
        save_frame(inputframeA); 
    }
    
#endif

#if 1
    /* Aufgabe 4: crossfade to videoB over 4s */
    fade_duration = 4.0 * 25.0;

    for (frame = 0; frame < (int) fade_duration; frame++)
    {
        __m128 alpha, beta;
        /* 1. Calculate beta */
        beta = _mm_set1_ps (((float) frame) / fade_duration);

        /* 2. Calculate alpha  (alpha = 1 - beta) */
        alpha = _mm_sub_ps (_mm_set1_ps (1.0f), beta);

        load_next_frame_from_videoA(inputframeA);
        load_next_frame_from_videoB(inputframeB);

        for (i=0; i < IMAGE_SIZE * 4; i+= 4)
        {
            __m128 vektorA, vektorB, ergebnis;
            /* 3. Lade 4 floats in 'vektorA' */
            vektorA = _mm_load_ps (&inputframeA[i]);

            /* 4. Lade 4 floats in 'vektorB' */
            vektorB = _mm_load_ps (&inputframeB[i]);

            /* 5. Berechne 'ergebnis'. Nutze dazu evtl. nötige Zwischenergebnisse*/
            __m128 betaB, alphaA;
            alphaA = _mm_mul_ps (alpha, vektorA);
            betaB = _mm_mul_ps (beta, vektorB);
            ergebnis = _mm_add_ps (betaB, alphaA);
            
            /* 6. Speichere 'ergebnis' is outputframe*/
            _mm_store_ps (&outputframe[i], ergebnis);
            
        }
        
        save_frame (outputframe);
    }
#endif


#if 1 
    /* Aufgabe 5: display videoB for 2s */
    fade_duration = 2.0 * 25.0;
    
    for (frame = 0; frame < (int) fade_duration; frame++) {
        load_next_frame_from_videoB (inputframeB);
        save_frame(inputframeB); 
    }

#endif

#if 1 
    /* Aufgabe 6: fade out videoB into green over 2s */
    fade_duration = 2.0 * 25.0;

    __m128 green;
    green = _mm_set_ps (0.0f, 0.0f, 1.0f, 0.0f);
    
    for (frame = 0; frame < (int) fade_duration; frame++)
    {
        __m128 alpha, beta;
        /* 1. Calculate beta */
        beta = _mm_set1_ps (((float) frame) / fade_duration);

        /* 2. Calculate alpha  (alpha = 1 - beta) */
        alpha = _mm_sub_ps (_mm_set1_ps (1.0f), beta);

        load_next_frame_from_videoB(inputframeB);

        for (i=0; i < IMAGE_SIZE * 4; i+= 4)
        {
            __m128 vektorB, ergebnis;
            /* 3. Lade 4 floats in 'vektorB' */
            vektorB = _mm_load_ps (&inputframeB[i]);

            /* 5. Berechne 'ergebnis'. Nutze dazu evtl. nötige Zwischenergebnisse*/
            __m128 betagreen, alphaB;
            alphaB = _mm_mul_ps (alpha, vektorB);
            betagreen = _mm_mul_ps (beta, green);
            ergebnis = _mm_add_ps (betagreen, alphaB);
            
            /* 6. Speichere 'ergebnis' is outputframe*/
            _mm_store_ps (&outputframe[i], ergebnis);
        }
        save_frame(outputframe);
    }
            
#endif

#if 1 
    /* Aufgabe 7: 1s gruen zum Schluß */
    save_for_seconds (outputframe, 1);
    
#endif
            



    shutdown_devil();
    return 0;
}
