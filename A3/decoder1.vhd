-- dec1_out : OUT fsm_states
-- CASE instr_in(26 TO 31) IS
    WHEN rr_func_add =>
        dec1_out <= add;
    WHEN rr_func_and =>
        dec1_out <= and_1;
    WHEN rr_func_or =>
        dec1_out <= or_1;
    WHEN rr_func_sll =>
        dec1_out <= sll_1;
    WHEN rr_func_srl =>
        dec1_out <= srl_1;
-- ...
-- END CASE;
WHEN op_sub_i =>
    dec1_out <= sub;
WHEN op_add_i =>
    dec1_out <= add;
WHEN op_and_i =>
    dec1_out <= and_1;
WHEN op_or_i =>
    dec1_out <= or_1;
WHEN op_sll_i =>
    dec1_out <= sll_1;
WHEN op_srl_i =>
    dec1_out <= srl_1;
