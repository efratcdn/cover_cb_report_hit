File name     : example_report_when_cover_hit.e 
Title         : Coverage callback examples
Project       : Utilities examples
Created       : 2020
              :
Description   :  Demonstrating the report when cover hit utility.
  
                 This utility allows getting notified when a
                 specified cover item is sampled with a specified value.
  
                 Importing the sample env.e, and requesting to get 
                 informed when a specific bucket is sampled with 
                 a specific value - the cover group env.cover_me, 
                 the cross item cross__legal__kind__address samples the value 
                 TRUE__CCC_2__mid-address
                   
                
<'
import e_util_report_when_cover_hit.e;
import sample_env;

// In our example, we want to stop the run after reached the goal, 
// covered the specified buckets
extend cb_notify_cover_hit {
    on cover_was_hit {
        message(LOW, "Coverage goal was hit, ",
                "stop the test");
        start stop_after_delay(100);
    };
    stop_after_delay(delay : uint) @sys.any is {
        wait [delay] * cycle;
        stop_run();
    };
};

extend sys {
    // Instantiate a coverage callback struct
    // (see its implementation in e_util_report_when_cover_hit.e)
    !cb : cb_notify_cover_hit;

    run() is also {
        cb = new;

        // Register the cover_me coverage group to the coverage 
        // callback struct
        cb.register(rf_manager.get_type_by_name("env").
                    as_a(rf_struct).get_cover_group("cover_me"));        
        // Request to notify when this bucket is sampled.
        // That is - when legal == TRUE, kind == CCC_2, 
        // and address is in the mid address range
        cb.report_of_items("cover_me",
                           "cross__legal__kind__address", 
                           "TRUE__CCC_2__mid address");
        
        // For sake of example - can register more than one group and bucket.
        // You can uncomment these lines
        // Register the item_ended coverage group to the coverage callback struct
        //cb.register(rf_manager.get_type_by_name("env_2").
          //          as_a(rf_struct).get_cover_group("item_ended"));  
        // Request to notify when this bucket is sampled.
        // That is - when kind == BAD_1
        //cb.report_of_items("item_ended", "kind", "BAD_1");
    };
};
'>

