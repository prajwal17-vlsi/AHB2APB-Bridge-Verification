class bridge_scoreboard extends uvm_scoreboard;

`uvm_component_utils(bridge_scoreboard)

uvm_tlm_analysis_fifo#(ahb_xtn) ahb_fifo;
uvm_tlm_analysis_fifo#(apb_xtn) apb_fifo;

ahb_xtn ahb_h;
apb_xtn apb_h;


covergroup ahb_cg;
HADDR:coverpoint ahb_h.Haddr{
			bins slave1={[32'h8000_0000:32'h8000_03ff]};
			bins slave2={[32'h8400_0000:32'h8400_03ff]};
			bins slave3={[32'h8800_0000:32'h8800_03ff]};
			bins slave4={[32'h8c00_0000:32'h8c00_03ff]};
				}
HSIZE:coverpoint ahb_h.Hsize{
			bins one_byte={0};
			bins two_byte={1};
			bins four_byte={2};
				}
HTRANS:coverpoint ahb_h.Htrans{
			bins seq={2};
			bins non_seq={3};
				}
HWRITE:coverpoint ahb_h.Hwrite;


cross HADDR,HSIZE,HTRANS,HWRITE;
			
endgroup


covergroup apb_cg;
PADDR:coverpoint apb_h.Paddr{
			bins slave1={[32'h8000_0000:32'h8000_03ff]};
			bins slave2={[32'h8400_0000:32'h8400_03ff]};
			bins slave3={[32'h8800_0000:32'h8800_03ff]};
			bins slave4={[32'h8c00_0000:32'h8c00_03ff]};
				}
PSELX:coverpoint apb_h.Pselx{
			bins slv1={1};
			bins slv2={2};
			bins slv3={4};
			bins slv4={8};				
				}
PWRITE:coverpoint apb_h.Pwrite;

cross PADDR,PSELX,PWRITE;

endgroup


function new(string name="bridge_scoreboard",uvm_component parent);
super.new(name,parent);
apb_cg=new();
ahb_cg=new();
endfunction 


function void build_phase(uvm_phase phase);
ahb_fifo=new("ahb_fifo",this);
apb_fifo=new("apb_fifo",this);
endfunction


task run_phase(uvm_phase phase);
forever
	begin
		fork
			begin
			ahb_fifo.get(ahb_h);
			ahb_h.print();
			ahb_cg.sample();
			end
		
			begin
			apb_fifo.get(apb_h);
			apb_h.print();
			apb_cg.sample();
			end
		join
	
	check_hp(ahb_h,apb_h);
	
	end
endtask



task compare_hp(int Haddr,Paddr,Hdata,Pdata);

if(Haddr==Paddr)
begin

$display("address is compared");
if(Hdata==Pdata)
$display("data is compared");
else
begin
	$display("data is failed");
	$display("Hdatar=%0d,Pdata=%0d",Hdata,Pdata);
end
end
else
begin
	$display("address is failed");
	$display("Haddr=%0d,Paddr=%0d",Haddr,Paddr);
end


endtask



task check_hp(ahb_xtn ahb,apb_xtn apb);

if(ahb.Hwrite==1)
begin
	if(ahb.Hsize==2'b00)
	begin
		if(ahb.Haddr[1:0]==2'b00)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hwdata[7:0],apb.Pwdata[7:0]);
		if(ahb.Haddr[1:0]==2'b01)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:8],apb.Pwdata[7:0]);
		if(ahb.Haddr[1:0]==2'b10)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hwdata[23:16],apb.Pwdata[7:0]);
		if(ahb.Haddr[1:0]==2'b11)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:24],apb.Pwdata[7:0]);
	end
	if(ahb.Hsize==2'b01)
	begin
		if(ahb.Haddr[1:0]==2'b00)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:0],apb.Pwdata[15:0]);
		if(ahb.Haddr[1:0]==2'b10)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:16],apb.Pwdata[15:0]);
	end
	if(ahb.Hsize==2'b10)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hwdata,apb.Pwdata);
end
if(ahb.Hwrite==0)
begin
	if(ahb.Hsize==2'b00)
	begin
		if(ahb.Haddr[1:0]==2'b00)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hrdata[7:0],apb.Prdata[7:0]);
		if(ahb.Haddr[1:0]==2'b01)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hrdata[15:8],apb.Prdata[7:0]);
		if(ahb.Haddr[1:0]==2'b10)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hrdata[23:16],apb.Prdata[7:0]);
		if(ahb.Haddr[1:0]==2'b11)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hrdata[31:24],apb.Prdata[7:0]);
	end
	if(ahb.Hsize==2'b01)
	begin
		if(ahb.Haddr[1:0]==2'b00)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hrdata[15:0],apb.Prdata[15:0]);
		if(ahb.Haddr[1:0]==2'b10)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hrdata[31:16],apb.Prdata[15:0]);
	end
	if(ahb.Hsize==2'b10)
		compare_hp(ahb.Haddr,apb.Paddr,ahb.Hrdata,apb.Prdata);
end


endtask



endclass
