class apb_driver extends uvm_driver#(apb_xtn);

virtual bridge_if.APB_DR vif;
apb_config m_cfg;

`uvm_component_utils(apb_driver)


function new(string name="apb_driver",uvm_component parent);
super.new(name,parent);
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
	send_to_dut();
endtask

task send_to_dut();
req=apb_xtn::type_id::create("req");

while(vif.apb_drv_cb.Pselx!==1||2||4||8)
@(vif.apb_drv_cb);

if(vif.apb_drv_cb.Pwrite==0)
vif.apb_drv_cb.Prdata<=$random;

@(vif.apb_drv_cb);

req.print();

endtask





endclass
