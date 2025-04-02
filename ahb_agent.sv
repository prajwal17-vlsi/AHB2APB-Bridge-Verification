class ahb_agent extends uvm_agent;

`uvm_component_utils(ahb_agent)

ahb_monitor monh;
ahb_driver drvh;
ahb_sequencer seqrh;
ahb_config m_cfg;

function new(string name="ahb_agent",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db#(ahb_config)::get(this,"","ahb_config",m_cfg))
`uvm_fatal(get_type_name(),"getting is failed")

monh=ahb_monitor::type_id::create("monh",this);

if(m_cfg.is_active)
begin
drvh=ahb_driver::type_id::create("drvh",this);
seqrh=ahb_sequencer::type_id::create("seqrh",this);
end

endfunction


function void connect_phase(uvm_phase phase);
if(m_cfg.is_active)
drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction


endclass
