class apb_monitor extends uvm_monitor;

`uvm_component_utils(apb_monitor)

uvm_analysis_port#(apb_xtn) apb_ap;

virtual bridge_if.APB_MON vif;
apb_config m_cfg;



function new(string name="apb_monitor",uvm_component parent);
super.new(name,parent);
apb_ap=new("apb_ap",this);
endfunction

function void build_phase(uvm_phase phase);
if(!uvm_config_db#(apb_config)::get(this,"","apb_config",m_cfg))
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
apb_xtn xtn;
xtn=apb_xtn::type_id::create("apb_xtn");
	
	while(vif.apb_mon_cb.Penable!==1)
	@(vif.apb_mon_cb);

	xtn.Pselx=vif.apb_mon_cb.Pselx;
	xtn.Penable=vif.apb_mon_cb.Penable;
	xtn.Pwrite=vif.apb_mon_cb.Pwrite;
	xtn.Paddr=vif.apb_mon_cb.Paddr;

	if(vif.apb_mon_cb.Pwrite)
	xtn.Pwdata=vif.apb_mon_cb.Pwdata;
	else
	xtn.Prdata=vif.apb_mon_cb.Prdata;
//	repeat(1)	
	@(vif.apb_mon_cb);
			
	xtn.print();
	
	apb_ap.write(xtn);	
endtask


endclass
