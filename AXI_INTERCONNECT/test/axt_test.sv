//  test class
   class base_test extends uvm_test;
      //factory register 
      `uvm_component_utils(base_test)
      //parameters
        int no_of_master=2;
        int no_of_slave=3;
        int no_of_rst_agt=1;
        bit has_sb=1;
        bit has_master=1;
        bit has_slave=1;
        bit has_rst_agt=1;
     //master and slave config handles
        m_cfg m_cfg_h[];
        s_cfg s_cfg_h[];
        rst_cfg r_cfg_h[];
     //base sequence handle
     //  m_seq seq1;
     //env config handles
      env_cfg e_cfg;
     //handles of env
      env env_h;
      //extern functions 
      extern function new (string name="base_test",uvm_component parent);
      extern function configuration();
      extern function void build_phase(uvm_phase phase);
      extern function void end_of_elaboration_phase(uvm_phase phase);
      //extern task run_phase(uvm_phase phase);
   endclass
    
  //--------------- constructor new --------------------
      function base_test::new (string name="base_test",uvm_component parent);
        super.new(name,parent);
      endfunction  

  //------------ configuration -----------------

     function base_test::configuration();
          //configuring master config
          if(has_master)
               begin
                  m_cfg_h=new[no_of_master];
                  foreach(m_cfg_h[i])
                      begin
                          m_cfg_h[i]=m_cfg::type_id::create($sformatf("m_cfg_h[%0d]",i));
                          m_cfg_h[i].is_active=UVM_ACTIVE;
                          if(!uvm_config_db #(virtual axi_master_interface) :: get(this, "", $sformatf("axi_mif_%0d",i),m_cfg_h[i].vif))
                             `uvm_fatal("TEST",$sformatf("master interface for m_cfg_h[%0d] get failed in a test",i))                          
                          e_cfg.m_cfg_h[i]=m_cfg_h[i];
                      end
               end
          //configuring master config
          if(has_slave)
               begin
                  s_cfg_h=new[no_of_slave];
                  foreach(s_cfg_h[i])
                      begin
                          s_cfg_h[i]=s_cfg::type_id::create($sformatf("s_cfg_h[%0d]",i));
                          s_cfg_h[i].is_active=UVM_ACTIVE;
                          if(!uvm_config_db #(virtual axi_slave_interface) :: get(this, "", $sformatf("axi_sif_%0d",i),s_cfg_h[i].vif))
                             `uvm_fatal("TEST",$sformatf("slave interface for s_cfg_h[%0d] get failed in a test",i))                             
                          e_cfg.s_cfg_h[i]=s_cfg_h[i];
                      end
               end
          //configuring master config
          if(has_rst_agt)
               begin
                  r_cfg_h=new[no_of_rst_agt];
                  foreach(r_cfg_h[i])
                      begin
                          r_cfg_h[i]=rst_cfg::type_id::create($sformatf("r_cfg_h[%0d]",i));
                          r_cfg_h[i].is_active=UVM_ACTIVE;
                          if(!uvm_config_db #(virtual reset_interface) :: get(this, "","reset_interface",r_cfg_h[i].vif))
                             `uvm_fatal("TEST",$sformatf("reset interface for r_cfg_h[%0d] get failed in a test",i))
                          e_cfg.r_cfg_h[i]=r_cfg_h[i];
                      end
               end


          //configuring env
          e_cfg.no_of_master=no_of_master;
          e_cfg.no_of_slave=no_of_slave;
          e_cfg.no_of_rst_agt=no_of_rst_agt;
          e_cfg.has_master=has_master;
          e_cfg.has_slave=has_slave;
          e_cfg.has_sb=has_sb;
          e_cfg.has_rst_agt=has_rst_agt;
     endfunction
  
 //---------------- build phase ---------------------
  
  function void base_test::build_phase(uvm_phase phase);
      //creating instance for env config
        e_cfg=env_cfg::type_id::create("e_cfg");
        e_cfg.m_cfg_h=new[no_of_master];
        e_cfg.s_cfg_h=new[no_of_slave];
        e_cfg.r_cfg_h=new[no_of_rst_agt];
      //calling confuration
        configuration();
      //set env_cfg
      uvm_config_db#(env_cfg)::set(this,"*","env_cfg",e_cfg);

      super.build_phase(phase);
      //creatig instance for the env
      env_h=env::type_id::create("env_h",this);
  endfunction

//----------------- end_of_elaboration_phase ----------------
    function void base_test::end_of_elaboration_phase(uvm_phase phase);
       uvm_top.print_topology;
    endfunction
/*
//--------------------run phase--------------------------------
        task base_test::run_phase(uvm_phase phase);
             super.run_phase(phase);
             phase.raise_objection(this);
                seq1=m_seq::type_id::create("seq1");
                begin
                    this.seq1.start(this.env_h.m_agt_top_h.m_agt_h[0].m_seqr_h);
                end
              #10000;
             phase.drop_objection(this);
           endtask
*/





//========================= CASE 1:FIXED TRANSACTION ==========================
    class fixed_burst_slv_0 extends base_test;
          `uvm_component_utils(fixed_burst_slv_0)
           //sequence handle
           fixed_seq_slv_0_mstr_0 seq1;
           fixed_seq_slv_0_mstr_1 seq2;

           function new (string name="fixed_burst_slv_0",uvm_component parent);
              super.new(name,parent);
           endfunction
           task run_phase(uvm_phase phase);
             super.run_phase(phase);
             phase.raise_objection(this);
                seq1=fixed_seq_slv_0_mstr_0::type_id::create("seq");
                seq2=fixed_seq_slv_0_mstr_1::type_id::create("seq");

                fork
                    this.seq1.start(this.env_h.m_agt_top_h.m_agt_h[0].m_seqr_h);
                    this.seq2.start(this.env_h.m_agt_top_h.m_agt_h[1].m_seqr_h);
                join
             phase.drop_objection(this);
           endtask
    endclass
  
//========================= CASE 2:INCREMENT TRANSACTION ==========================
    class incr_burst_slv_0 extends base_test;
          `uvm_component_utils(incr_burst_slv_0)
           //sequence handle
           incr_seq_slv_0_mstr_0 seq1;
           incr_seq_slv_0_mstr_1 seq2;

           function new (string name="incr_burst_slv_0",uvm_component parent);
              super.new(name,parent);
           endfunction
           task run_phase(uvm_phase phase);
             super.run_phase(phase);
             phase.raise_objection(this);
                seq1=incr_seq_slv_0_mstr_0::type_id::create("seq");
                seq2=incr_seq_slv_0_mstr_1::type_id::create("seq");

                fork
                    this.seq1.start(this.env_h.m_agt_top_h.m_agt_h[0].m_seqr_h);
                    this.seq2.start(this.env_h.m_agt_top_h.m_agt_h[1].m_seqr_h);
                join
             phase.drop_objection(this);
           endtask
    endclass
     
//========================= CASE 3:WRAP TRANSACTION ==========================
    class wrap_burst_slv_0 extends base_test;
          `uvm_component_utils(wrap_burst_slv_0)
           //sequence handle
           wrap_seq_slv_0_mstr_0 seq1;
           wrap_seq_slv_0_mstr_1 seq2;

           function new (string name="wrap_burst_slv_0",uvm_component parent);
              super.new(name,parent);
           endfunction
           task run_phase(uvm_phase phase);
             super.run_phase(phase);
             phase.raise_objection(this);
                seq1=wrap_seq_slv_0_mstr_0::type_id::create("seq");
                seq2=wrap_seq_slv_0_mstr_1::type_id::create("seq");

                fork
                    this.seq1.start(this.env_h.m_agt_top_h.m_agt_h[0].m_seqr_h);
                    this.seq2.start(this.env_h.m_agt_top_h.m_agt_h[1].m_seqr_h);
                join
             phase.drop_objection(this);
           endtask
    endclass

//========================= CASE 4:UNALIGNED TRANSACTION ==========================
    class unaligned_transfer_slv_0 extends base_test;
          `uvm_component_utils(unaligned_transfer_slv_0)
           //sequence handle
           unaligned_seq_slv_0_mstr_0 seq1;
           unaligned_seq_slv_0_mstr_1 seq2;

           function new (string name="unaligned_burst_slv_0",uvm_component parent);
              super.new(name,parent);
           endfunction
           task run_phase(uvm_phase phase);
             super.run_phase(phase);
             phase.raise_objection(this);
                seq1=unaligned_seq_slv_0_mstr_0::type_id::create("seq");
                seq2=unaligned_seq_slv_0_mstr_1::type_id::create("seq");

                fork
                    this.seq1.start(this.env_h.m_agt_top_h.m_agt_h[0].m_seqr_h);
                    this.seq2.start(this.env_h.m_agt_top_h.m_agt_h[1].m_seqr_h);
                join
             phase.drop_objection(this);
           endtask
    endclass
 
//========================= CASE 4:MULTIPLE OUTSTANDING ==========================
    class mult_outstanding_seq_slv_0 extends base_test;
          `uvm_component_utils(mult_outstanding_seq_slv_0)
           //sequence handle
           mult_outstanding_seq_slv_0_mstr_0 seq1;
           mult_outstanding_seq_slv_0_mstr_1 seq2;

           function new (string name="mult_outstanding_seq_slv_0",uvm_component parent);
              super.new(name,parent);
           endfunction
           task run_phase(uvm_phase phase);
             super.run_phase(phase);
             phase.raise_objection(this);
                seq1=mult_outstanding_seq_slv_0_mstr_0::type_id::create("seq");
                seq2=mult_outstanding_seq_slv_0_mstr_1::type_id::create("seq");

                begin
                    this.seq1.start(this.env_h.m_agt_top_h.m_agt_h[0].m_seqr_h);
                    this.seq2.start(this.env_h.m_agt_top_h.m_agt_h[1].m_seqr_h);
                end
             phase.drop_objection(this);
           endtask
    endclass
           
