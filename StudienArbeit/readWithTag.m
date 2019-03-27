function myObj=readWithTag(obj,key)
    hdt=findall(0,'tag',obj);
    myObj=get(hdt,key);
end