class apb_agent extends uvm_agent;

`uvm_component_utils(apb_agent)

apb_monitor monh;
apb_driver drvh;
apb_sequencer seqrh;
//env_config m_cfg;

function new(string name="apb_agent",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
//if(!uvm_config_db#(env_config)::get(this,"","env_config",m_cfg))
//`uvm_fatal(get_type_name(),"getting is failed")

monh=apb_monitor::type_id::create("monh",this);

//if(m_cfg.is_active)
begin
drvh=apb_driver::type_id::create("drvh",this);
seqrh=apb_sequencer::type_id::create("seqrh",this);
end


endfunction



function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
uvm_top.print_topology;
endfunction


endclass

