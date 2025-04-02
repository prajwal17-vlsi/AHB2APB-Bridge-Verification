class btest extends uvm_test;

`uvm_component_utils(btest)

env_config m_cfg; 
apb_config pcfg;
ahb_config hcfg;
bridge_env envh;

bit has_hagent=1;
bit has_pagent=1;
bit has_virtual_sequencer=1;
bit has_scoreboard=1;

function new(string name="btest",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
m_cfg=env_config::type_id::create("m_cfg");
pcfg=apb_config::type_id::create("pcfg");
hcfg=ahb_config::type_id::create("hcfg");

if(!uvm_config_db#(virtual bridge_if)::get(this,"","vif",hcfg.vif))
`uvm_fatal(get_type_name(),"getting is failed");
hcfg.is_active=UVM_ACTIVE;
m_cfg.h_cfg=hcfg;

if(!uvm_config_db#(virtual bridge_if)::get(this,"","vif0",pcfg.vif))
`uvm_fatal(get_type_name(),"getting is failed");
pcfg.is_active=UVM_ACTIVE;
m_cfg.p_cfg=pcfg;

m_cfg.has_virtual_sequencer=has_virtual_sequencer;
m_cfg.has_scoreboard=has_scoreboard;
m_cfg.has_hagent=has_hagent;
m_cfg.has_pagent=has_pagent;


uvm_config_db#(env_config)::set(this,"*","env_config",m_cfg);


envh=bridge_env::type_id::create("ahb_h",this);
endfunction


endclass

//////////////////////////////////////////////////
/////////////////////////////////////////////////

class single_test extends btest;

`uvm_component_utils(single_test)

single_trans seqh;

function new(string name="single_test",uvm_component parent);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction


task run_phase(uvm_phase phase);

phase.raise_objection(this);

seqh=single_trans::type_id::create("seqh");

seqh.start(envh.ahb_h.seqrh);

#100;

phase.drop_objection(this);

endtask

endclass

//////////////////////////////////////////////////
/////////////////////////////////////////////////

class incr_test extends btest;

`uvm_component_utils(incr_test)

incr_trans seqh;

function new(string name="incr_test",uvm_component parent);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction


task run_phase(uvm_phase phase);

phase.raise_objection(this);

seqh=incr_trans::type_id::create("seqh");

seqh.start(envh.ahb_h.seqrh);

#100;

phase.drop_objection(this);

endtask

endclass
//////////////////////////////////////////////////
/////////////////////////////////////////////////


class wrap_test extends btest;

`uvm_component_utils(wrap_test)

wrap_trans seqh;

function new(string name="wrap_test",uvm_component parent);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction


task run_phase(uvm_phase phase);

phase.raise_objection(this);

seqh=wrap_trans::type_id::create("seqh");

seqh.start(envh.ahb_h.seqrh);

#100;

phase.drop_objection(this);

endtask

endclass

