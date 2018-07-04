WHEN sub           =>
    s1_enab      <= s1_a;
    s2_enab      <= s2_Y;
    alu_op_sel   <= alu_s1_sub_s2;
    dest_enab    <= dest_c;
    const_sel    <= const_dcare;
    rf_op_sel    <= rfop_none;
    immed_sel    <= imm_s16;
    mem_ctrl     <= mem_none;
    state_number <= sub_no;
WHEN add           =>
    s1_enab      <= s1_a;
    s2_enab      <= s2_Y;
    alu_op_sel   <= alu_s1_add_s2;
    dest_enab    <= dest_c;
    const_sel    <= const_dcare;
    rf_op_sel    <= rfop_none;
    immed_sel    <= imm_s16;
    mem_ctrl     <= mem_none;
    state_number <= add_no;
WHEN and_1           =>
    s1_enab      <= s1_a;
    s2_enab      <= s2_Y;
    alu_op_sel   <= alu_s1_and_s2;
    dest_enab    <= dest_c;
    const_sel    <= const_dcare;
    rf_op_sel    <= rfop_none;
    immed_sel    <= imm_u16;    -- unsigned
    mem_ctrl     <= mem_none;
    state_number <= and_no;
WHEN or_1           =>
    s1_enab      <= s1_a;
    s2_enab      <= s2_Y;
    alu_op_sel   <= alu_s1_or_s2;
    dest_enab    <= dest_c;
    const_sel    <= const_dcare;
    rf_op_sel    <= rfop_none;
    immed_sel    <= imm_u16;    -- unsigned
    mem_ctrl     <= mem_none;
    state_number <= or_no;
WHEN sll_1           =>
    s1_enab      <= s1_a;
    s2_enab      <= s2_Y;
    alu_op_sel   <= alu_sll_s1_s2;
    dest_enab    <= dest_c;
    const_sel    <= const_dcare;
    rf_op_sel    <= rfop_none;
    immed_sel    <= imm_s16;
    mem_ctrl     <= mem_none;
    state_number <= sll_no;
WHEN srl_1           =>
    s1_enab      <= s1_a;
    s2_enab      <= s2_Y;
    alu_op_sel   <= alu_srl_s1_s2;
    dest_enab    <= dest_c;
    const_sel    <= const_dcare;
    rf_op_sel    <= rfop_none;
    immed_sel    <= imm_s16;
    mem_ctrl     <= mem_none;
    state_number <= srl_no;
