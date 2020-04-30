File name     : e_util_report_when_cover_hit.e 
Title         : Coverage callback examples
Project       : Utilities examples
Created       : 2020
              :
Description   :  Implementing a utility that notifies when 
                 specified bucket is being sampled.
  
                 Using the coverage callback hooks.
   
                 See details in the README.
   
                 Usage example in example_report_when_cover_hit.e
  
<'
struct item_info {
    item_name      : string;
    group_name     : string; 
    wanted_bucket  : string;
};

struct cb_notify_cover_hit like cover_sampling_callback {
    !items_of_interest : list of item_info;
    event cover_was_hit;  
    
    // report_of_items()
    //
    // Buckets values that user wants notification when hitting them
    report_of_items(group_name  : string, 
                    item_name   : string,
                    bucket_name : string) is {
        var item_info : item_info = new with {
            .group_name  = group_name;
            .item_name  = item_name;
            .wanted_bucket = bucket_name;
        };
        items_of_interest.add(item_info);
    };
    
    // do_callback()
    //
    // Implement the callback.
    // If sampled group has an item that is in the items_of_interest list -
    // check the sampled bucket. If it is the value we are waiting for - 
    // issue a notification
    do_callback() is only {
        if is_currently_per_type()  {
        
            var cr          : rf_cover_group = get_current_cover_group();
            var item_info   : item_info;
            var group_items := items_of_interest.all(.group_name ==
                                                     cr.get_name());
            var item_value  : string;
        
            for each (item) in cr.get_all_items() {
                
                if is_item_sampled(item) {
                
                    item_info = group_items.first(it.item_name ==
                                                  item.get_name()); 
                    if item_info != NULL {        
                        if item is a rf_cross_cover_item (cross_item) {
                            item_value = 
                              str_join(get_simple_cross_sampled_bucket_name(
                                  cross_item), "__");
                        } else {
                            item_value = 
                              get_simple_sampled_bucket_name(item);
                        };
                        if item_value == item_info.wanted_bucket {
                            message(LOW, "Sampled desired value - item ",
                                    item.get_name(), " == ", item_value );
                            emit cover_was_hit;
                        };
                    };
                };
            };
        };
    };
};

'>

