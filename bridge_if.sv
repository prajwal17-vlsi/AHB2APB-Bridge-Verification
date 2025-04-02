interface bridge_if(input bit Hclk);
logic [31:0]Hwdata,Hrdata,Haddr;
logic [1:0]Htrans,Hresp;
bit Hwrite,Hreadyout,Hrestn;
bit Hreadyin;
logic [2:0]Hsize;

bit Penable,Pwrite;
logic [31:0]Pwdata,Prdata,Paddr;
logic [3:0]Pselx;



clocking ahb_drv_cb@(posedge Hclk);
default input #1 output #0;
output Hwdata,Haddr;
output Htrans;
output Hwrite,Hreadyin,Hrestn;
output Hsize;
input Hreadyout,Hresp;
endclocking

clocking ahb_mon_cb@(posedge Hclk);
default input #1 output #1;
input Hwdata,Haddr;
input Htrans;
input Hwrite,Hreadyin,Hrestn;
input Hsize;
input Hreadyout,Hresp,Hrdata;
endclocking

clocking apb_drv_cb@(posedge Hclk);
default input #1 output #0;
output Prdata;
input Pselx,Pwrite;
input Pwdata,Penable;
input Paddr;
endclocking 

clocking apb_mon_cb@(posedge Hclk);
default input #1 output #1;
input Prdata;
input Pselx,Pwrite;
input Pwdata,Penable;
input Paddr;
endclocking 



modport AHB_DR (clocking ahb_drv_cb);
modport AHB_MON (clocking ahb_mon_cb);
modport APB_DR (clocking apb_drv_cb);
modport APB_MON (clocking apb_mon_cb);


endinterface

