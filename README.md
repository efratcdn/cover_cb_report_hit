# cover_cb_report_hit
* Title       : Report when cover hit  
* Version     : 1.0
* Requires    : Specman {20.03...}
* Modified    : April 2020
* Description :

[ More e examples in https://github.com/efratcdn/spmn-e-utils ]

This directory contains three files:

    e_util_report_when_cover_hit.e  : Implementing the utility
    example_report_when_cover_hit.e : Example of using the utility 
    sample_env.e                    : Basic "testbench", used by the example

Running the demo:

   specman -c 'load example_report_when_cover_hit.e ; test'

This utility is implemented using the coverage callback api.
It notifies when a specified bucket is being sampled. That is - the cover
item gets a specific value. Or, in case of a cross coverage - the 
participated items get the specified values.
 

Flow example:
Assume there is a hole in the coverage, a very specific bucket was not 
reached in any test. You run a test, trying to fill this hole (by setting 
constraints, starting sequences that are due to get the are of interest, etc).
You can stop the run once this hole was covered, when the desired value was
sampled.

   
The coverage callback struct implementation:
  
     Maintaining a list of items_of_interest.
     When do_callback is called, that is - a registered cover
     group is being sampled, checking if any of the items in 
     this cover group exists in the items_of_interest list.
     If yes - compares the sampled value to the wanted_bucket.
     If there is a match - emits an event.
  
This is an example, can be used as base to your own utilities, based on 
your requirements and preferences.
 
Examples of changes:
   -) Instead of emitting an event, can write to an external data
      base, to be analyzed post run.
   -) Check for specific instance (this implementation looks at the 
      per-type grade)
