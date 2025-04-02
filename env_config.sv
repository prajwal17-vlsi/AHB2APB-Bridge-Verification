class env_config extends uvm_object;

`uvm_object_utils(env_config)

ahb_config h_cfg;
apb_config p_cfg;

bit has_hagent;
bit has_pagent;
bit has_scoreboard;
bit has_virtual_sequencer;

function new(string name="env_config");
super.new(name);
endfunction


endclass
