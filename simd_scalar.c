#if 1
    for (frame = 0; frame < (int) fade_duration; frame++)
    {
        float skalar;
        load_next_frame_from_videoA (inputframeA);
        skalar = ((float) frame) / fade_duration;

        for (i=0; i < IMAGE_SIZE*4; i++)
        {
            float floatvektor, ergebnis;
            /* 1. Lade 1 float in 'floatvektor' */
            floatvektor = inputframeA[i];
            /* 2. Multipliziere 'floatvektor' mit 'skalar'*/
            ergebnis = skalar * floatvektor;
            /* 3. Speichere 'ergebnis' is outputframe*/
            outputframe[i] = ergebnis;
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
        float alpha, beta;
        /* 1. Calculate beta */
        beta = ((float) frame) / fade_duration;

        /* 2. Calculate alpha  (alpha = 1 - beta) */
        alpha = 1 - beta;

        load_next_frame_from_videoA(inputframeA);
        load_next_frame_from_videoB(inputframeB);

        for (i=0; i < IMAGE_SIZE*4; i++)
        {
            float vektorA, vektorB, ergebnis;
            /* 3. Lade 4 floats in 'vektorA' */
            vektorA = inputframeA[i];

            /* 4. Lade 4 floats in 'vektorB' */
            vektorB = inputframeB[i];

            /* 5. Berechne 'ergebnis'.*/
            float betaB, alphaA;
            alphaA = alpha * vektorA;
            betaB = beta * vektorB;
            ergebnis = betaB + alphaA;

            /* 6. Speichere 'ergebnis' is outputframe*/
            outputframe[i] = ergebnis;

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

    for (frame = 0; frame < (int) fade_duration; frame++)
    {
        float alpha, beta;
        /* 1. Calculate beta */
        beta = ((float) frame) / fade_duration;

        /* 2. Calculate alpha  (alpha = 1 - beta) */
        alpha = 1 - beta;

        load_next_frame_from_videoB(inputframeB);

        for (i=0; i < IMAGE_SIZE*4; i++)
        {
            float vektorB, ergebnis;
            /* 3. Lade 4 floats in 'vektorB' */
            vektorB = inputframeB[i];

            /* 5. Berechne 'ergebnis'.*/
            float betagreen, alphaB;
            alphaB = alpha * vektorB;
            ergebnis = alphaB + beta*(i%4==1);

            /* 6. Speichere 'ergebnis' is outputframe*/
            outputframe[i] = ergebnis;
        }
        save_frame(outputframe);
    }
#endif
