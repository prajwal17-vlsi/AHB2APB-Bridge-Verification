class bridge_env extends uvm_env;

`uvm_component_utils(bridge_env)


ahb_agent ahb_h;
apb_agent apb_h;
env_config m_cfg;

bridge_scoreboard sb;
virtual_sequencer v_seq;

function new(string name="bridge_env",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db#(env_config)::get(this,"","env_config",m_cfg))
`uvm_fatal(get_type_name(),"getting is failed")

if(m_cfg.has_hagent)
begin
ahb_h=ahb_agent::type_id::create("ahb_h",this);
uvm_config_db#(ahb_config)::set(this,"ahb_h*","ahb_config",m_cfg.h_cfg);
end

if(m_cfg.has_hagent)
begin
apb_h=apb_agent::type_id::create("apb_h",this);
uvm_config_db#(apb_config)::set(this,"apb_h*","apb_config",m_cfg.p_cfg);
end

if(m_cfg.has_scoreboard)
sb=bridge_scoreboard::type_id::create("sb",this);

if(m_cfg.has_virtual_sequencer)
v_seq=virtual_sequencer::type_id::create("v_seq",this);

endfunction


function void connect_phase(uvm_phase phase);
if(m_cfg.has_scoreboard)
begin
ahb_h.monh.ahb_ap.connect(sb.ahb_fifo.analysis_export);
apb_h.monh.apb_ap.connect(sb.apb_fifo.analysis_export);
end

endfunction 


endclass
