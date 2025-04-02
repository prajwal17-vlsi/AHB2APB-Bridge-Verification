module top;

import uvm_pkg::*;
import bridge_test_pkg::*;


bit Hclk;

always 
	#5 Hclk=~Hclk;

bridge_if in(Hclk),in0(Hclk);


rtl_top DUV( .Hclk(Hclk),.Hresetn(in.Hrestn),.Htrans(in.Htrans),
		.Hsize(in.Hsize),.Hreadyin(in.Hreadyin),.Hreadyout(in.Hreadyout),
		.Hwdata(in.Hwdata),.Hrdata(in.Hrdata),.Haddr(in.Haddr),.Hwrite(in.Hwrite),.Hresp(in.Hresp),
		.Penable(in0.Penable),.Pwrite(in0.Pwrite),.Pwdata(in0.Pwdata),.Prdata(in0.Prdata),.Paddr(in0.Paddr),.Pselx(in0.Pselx));




initial 
begin
	uvm_config_db#(virtual bridge_if)::set(null,"*","vif",in);
	uvm_config_db#(virtual bridge_if)::set(null,"*","vif0",in0);	
	run_test("btest");
end
endmodule
