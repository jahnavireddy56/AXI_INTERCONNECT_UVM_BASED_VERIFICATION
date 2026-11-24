//env configuration class
  class env_cfg extends uvm_object;
       //factory registration 
       `uvm_object_utils(env_cfg)
       //parameters
        int no_of_master;
        int no_of_slave;
        int no_of_rst_agt;
        bit has_sb;
        bit has_master;
        bit has_slave;
        bit has_rst_agt;
       //master and slave config handles
        m_cfg m_cfg_h [];
        s_cfg s_cfg_h [];
        rst_cfg r_cfg_h[];
       //extern funtion 
        extern function new (string name="env_cfg");
  endclass
  
  //constructor new
         function env_cfg::new (string name="env_cfg");
            super.new(name);
         endfunction



