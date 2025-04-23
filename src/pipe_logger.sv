task pipe_logger;
    input int cycle;
    input logic [31:0] pc_f, pc_d, pc_e, pc_m, pc_w;
    input string file;

    integer fd;
    fd = $fopen(file, "a");

    $fdisplay(fd, "%0d\t%s\t%s\t%s\t%s\t%s", 
              cycle,
              (pc_f == 32'hFFFFFFFF ? "Flushed" : $sformatf("0x%08h", pc_f)),
              (pc_d == 32'hFFFFFFFF ? "Flushed" : $sformatf("0x%08h", pc_d)),
              (pc_e == 32'hFFFFFFFF ? "Flushed" : $sformatf("0x%08h", pc_e)),
              (pc_m == 32'hFFFFFFFF ? "Flushed" : $sformatf("0x%08h", pc_m)),
              (pc_w == 32'hFFFFFFFF ? "Flushed" : $sformatf("0x%08h", pc_w)));

    $fclose(fd);


endtask
