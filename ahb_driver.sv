class ahb_driver extends uvm_driver#(ahb_xtn);

virtual bridge_if.AHB_DR vif;
ahb_config m_cfg;

`uvm_component_utils(ahb_driver)


function new(string name="ahb_driver",uvm_component parent);
super.new(name,parent);
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
@(vif.ahb_drv_cb);
vif.ahb_drv_cb.Hrestn<=1'd0;
@(vif.ahb_drv_cb);
vif.ahb_drv_cb.Hrestn<=1'd1;
forever
	begin	
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		//req.print;
		seq_item_port.item_done;
	end
endtask


task send_to_dut(ahb_xtn req);


while(vif.ahb_drv_cb.Hreadyout!==1)
@(vif.ahb_drv_cb);

vif.ahb_drv_cb.Haddr<=req.Haddr;
vif.ahb_drv_cb.Hsize<=req.Hsize;
vif.ahb_drv_cb.Htrans<=req.Htrans;
vif.ahb_drv_cb.Hwrite<=req.Hwrite;
vif.ahb_drv_cb.Hreadyin<=1'b1;


@(vif.ahb_drv_cb);

while(vif.ahb_drv_cb.Hreadyout!==1)
@(vif.ahb_drv_cb);

if(req.Hwrite)
vif.ahb_drv_cb.Hwdata<=req.Hwdata;
else 
vif.ahb_drv_cb.Hwdata<=0;

req.print();


endtask


endclass
