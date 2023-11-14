Inventory = {}
Inventory.__index = Inventory

function Inventory:Inventory(object)
    local self = setmetatable({}, Inventory)
    self.m_object = object
    self.m_inventory = {}
   
    self:GetInventory()

    return self
end

function Inventory:GetInventory(size)
    size = self.m_object.size() or 16
    for i = 1, size do   
        local details = self.m_object.getItemDetail(i)
        table.insert(self.m_inventory, {m_index = i, m_item_details = details})
    end
end

function Inventory:GetData(item_name)
    local max_count = 0
    local old_count = 0

    local item_data = {}
    item_data.has_item = false
    for _, item in ipairs(self.m_inventory) do
        if item.m_item_details and item.m_item_details.name == item_name then
            max_count = item.m_item_details.count

            if old_count < max_count then
               item_data.has_item = true
               item_data.m_index = item.m_index
            end
        end
        old_count = max_count
    end

    return item_data
end

function Inventory:MoveTo(Inventory, item_index, count)
    count = count or 64

    local other_object = Inventory.m_object
    local name = peripheral.getName(other_object)

    local should_return = false

    for k, v in ipairs(Inventory.m_inventory) do
        if v.m_item_details then
           should_return = true 
        else should_return = false
        end
    end

    if should_return then
       return
    end

    self.m_object.pushItems(name, item_index, count)
end
