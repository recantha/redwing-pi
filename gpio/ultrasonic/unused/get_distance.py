#/bin/python  
import subprocess  
sonar = subprocess.Popen(['./sonar'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)  
out, err = sonar.communicate()  
split_output = out.split('\n')  
results_list = []  
for line in split_output:  
    if line.startswith('echo'):  
	    results_list.append(int(line.split()[2].strip()))  
print "Results : %s" % results_list  
print "avg : %d" % (sum(results_list)/10)  
