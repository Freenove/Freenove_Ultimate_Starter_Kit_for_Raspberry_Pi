import os  
import shutil  
import tarfile  
from pathlib import Path  

os.system("sudo apt-get remove --purge openjdk-\*")
os.system("sudo apt-get install default-jdk")

home_dir = Path.home()  
jbang_dir = home_dir / '.jbang'  
tar_file = Path('.') / 'jbang-0.119.0.tar'  
temp_dir = home_dir / 'jbang_temp'  
bashrc_file = home_dir / '.bashrc'  
if jbang_dir.exists():  
    shutil.rmtree(jbang_dir)  
temp_dir.mkdir()  
with tarfile.open(tar_file, 'r') as tar:  
    tar.extractall(path=temp_dir)  
top_level_dirs = [d for d in temp_dir.iterdir() if d.is_dir()]  
if not top_level_dirs:  
    print(f"Error: No top-level directory found in {tar_file}")  
    shutil.rmtree(temp_dir)  
    exit(1)  
top_level_dir = top_level_dirs[0]  
shutil.move(top_level_dir, jbang_dir)  
bin_dir = jbang_dir / 'bin'  
if not bin_dir.exists():  
    bin_dir.mkdir()  
shutil.rmtree(temp_dir)    
print(f"\nSuccessfully extracted and moved contents of {tar_file} to {jbang_dir}")  
with open(bashrc_file, 'a') as f:  
    f.write('\nexport PATH="$HOME/.jbang/bin:$PATH"\n')     
print(f"Added export PATH=\"$HOME/.jbang/bin:$PATH\" to {bashrc_file}")

print("\nPlease run the following command in your terminal to update your PATH:")  
print("1, source ~/.bashrc")  
print("2, jbang --version")  
  

