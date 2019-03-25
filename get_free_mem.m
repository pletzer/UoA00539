function memKB = get_free_mem()
  [~,out]=system('vmstat -s | grep "free memory"');
  memKB = sscanf(out,'%f  free memory');
end
