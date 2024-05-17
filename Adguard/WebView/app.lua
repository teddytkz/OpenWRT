module("luci.controller.app", package.seeall)  --notice that new_tab is the name of the file new_tab.lua
 function index()
    entry({"admin","system","adguard"}, template("adguard"), "Adguard", 47).leaf=true
    --entry({"admin", "app", "adguard"}, template("adguard"), "Adguard", 1)  --this adds the second sub-tab that is located in <luci-path>/luci-myapplication/view/myapp-mymodule and the file is called view_tab.htm, also set to the second position
end
