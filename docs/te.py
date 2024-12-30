import re  
  
# 示例路径  
paths = [  
    "/some/directory/fnk0020/codes/myfile.txt",  
    "/another/path/fnk00ab/codes/somefile.doc",  
    "/no_match_here/fnk00/not_codes/something.else",  
    "/matching/fnk00123xyz/codes/anotherfile.pdf",
    "source/fnk0020/codes",
    "source/fnk0066/codes",
]  
  
# 正则表达式模式  
pattern = r".*/fnk00[0-9a-zA-Z]*/codes.*"  
  
# 遍历路径列表并检查匹配  
for path in paths:  
    if re.match(pattern, path):  
        print(f"路径 {path} 匹配！")  
    else:  
        print(f"路径 {path} 不匹配。")