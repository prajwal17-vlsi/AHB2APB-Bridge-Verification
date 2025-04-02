class ahb_bseqs extends uvm_sequence#(ahb_xtn);

`uvm_object_utils(ahb_bseqs)

bit [2:0]hsize,hburst;
bit [31:0]haddr;
bit hwrite;
bit [9:0]hlength;

function new(string name="ahb_bseqs");
super.new(name);
endfunction


endclass


///////////////////////////////////////////////////
//////////////////////////////////////////////////

class single_trans extends ahb_bseqs;

`uvm_object_utils(single_trans)

function new(string name="single_trans");
super.new(name);
endfunction

task body();
req=ahb_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {Htrans==2'b10;Hburst==0;Hwrite==1;});
finish_item(req);
endtask

endclass


///////////////////////////////////////////////////////
///////////////////////////////////////////////////////


class incr_trans extends ahb_bseqs;

`uvm_object_utils(incr_trans)

function new(string name="incr_trans");
super.new(name);
endfunction


task body();

req=ahb_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {Htrans==2'b10;Hburst inside {1,3,5,7};Hwrite==1;});
finish_item(req);

hwrite=req.Hwrite;
hburst=req.Hburst;
haddr=req.Haddr;
hlength=req.length;
hsize=req.Hsize;



for(int i=1;i<hlength;i++)
begin
	start_item(req);
	assert(req.randomize() with {Htrans==2'b11;
					Hburst==hburst;
					Hwrite==hwrite;
					Hsize==hsize;
					//length==hlength;
					Haddr==haddr+(2**hsize);})
	finish_item(req);
	haddr=req.Haddr;
end

endtask


endclass

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////



class wrap_trans extends ahb_bseqs;

bit [31:0]start_addr,boundry_addr;

`uvm_object_utils(wrap_trans)

function new(string name="wrap_trans");
super.new(name);
endfunction


task body();

req=ahb_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {Htrans==2'b10;Hburst inside {2,4,6};Hwrite==1;});
finish_item(req);

haddr=req.Haddr;
hwrite=req.Hwrite;
hburst=req.Hburst;
haddr=req.Haddr;
hlength=req.length;
hsize=req.Hsize;

start_addr=(haddr/(hlength*(2**hsize)))*(hlength*(2**hsize));

boundry_addr=start_addr+(hlength*(2**hsize));

haddr=req.Haddr+(2**hsize);

for(int i=1;i<hlength;i++)
begin
	if(haddr==boundry_addr)
		haddr=start_addr;
	start_item(req);
	assert(req.randomize() with {Htrans==2'b11;
						Hburst==hburst;
						Hwrite==hwrite;
						Hsize==hsize;
						//length==hlength;
						Haddr==haddr;});
	
	finish_item(req);

	haddr=req.Haddr+(2**hsize);
end

endtask

endclass
					


















