class ahb_monitor extends uvm_monitor;

`uvm_component_utils(ahb_monitor)

uvm_analysis_port#(ahb_xtn) ahb_ap;

virtual bridge_if.AHB_MON vif;
ahb_config m_cfg;


function new(string name="ahb_monitor",uvm_component parent);
super.new(name,parent);
ahb_ap=new("ahb_ap",this);
endfunction


function void build_phase(uvm_phase phase);
if(!uvm_config_db#(ahb_config)::get(this,"","ahb_config",m_cfg))
`uvm_fatal(get_type_name(),"getiing is failed")

super.build_phase(phase);
endfunction

function void connect_phase(uvm_phase phase);
vif=m_cfg.vif;
endfunction 

task run_phase(uvm_phase phase);
forever 
	collect_data();
endtask

task collect_data();
ahb_xtn xtn;

xtn=ahb_xtn::type_id::create("xtn");

	while(vif.ahb_mon_cb.Hreadyout!==1)
	@(vif.ahb_mon_cb);
	while(vif.ahb_mon_cb.Htrans !== 2'b11 && vif.ahb_mon_cb.Htrans !== 2'b10)
		@(vif.ahb_mon_cb);	
	xtn.Hwrite=vif.ahb_mon_cb.Hwrite;
	xtn.Haddr=vif.ahb_mon_cb.Haddr;
	xtn.Hsize=vif.ahb_mon_cb.Hsize;
	xtn.Hreadyin=vif.ahb_mon_cb.Hreadyin;
	xtn.Htrans=vif.ahb_mon_cb.Htrans;
	
	@(vif.ahb_mon_cb);
	
	while(vif.ahb_mon_cb.Hreadyout!==1)
	@(vif.ahb_mon_cb);

	if(vif.ahb_mon_cb.Hwrite==1)
	xtn.Hwdata=vif.ahb_mon_cb.Hwdata;
	else
	xtn.Hrdata=vif.ahb_mon_cb.Hrdata;
	
	xtn.print();

	ahb_ap.write(xtn);
	endtask

endclass
