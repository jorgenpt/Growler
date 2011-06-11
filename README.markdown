Growler
=======

Setup
-----

To set Growler up for use in your project, you need to configure it to build
with the Growl framework, then just drop the four files in this directory into
your project.

Growler has only been tested with Growl 1.2.x and above.

For instructions on setting up Growl in your project, see the official page on
[Implementing Growl][1], under the "Including and linking against the Growl
framework" header.

Using
-----

To Growl from any source file, you need the following at the start of the file:

    #import "Growler.h"

When you want to notify the user, you need to define what the Growl should
contain, with one of the following four constructors:

    myGrowl = [GrowlerGrowl growl];
    myGrowl = [GrowlerGrowl growlWithName:@"Operation completed"];
    myGrowl = [GrowlerGrowl growlWithName:@"Operation completed"
                                    title:@"Operation completed!"
                              description:@"The upload operation completed succesfully"];
    myGrowl = [GrowlerGrowl growlErrorWithTitle:@"Operation failed"
                                    description:@"Could not complete the upload"];

You can customize the growl with the following attributes:

    [myGrowl setTitle:@"Operation completed"];
    [myGrowl setDescription:@"The upload operation completed successfully"];
    [myGrowl setNotificationName:@"Operation completed"]; // Default: @"Default"

    /* This is the default for growlErrorWithTitle:description:
     * For the other constructors, it's nil.
     */
    [myGrowl setIcon:[NSImage imageNamed:NSImageNameCaution]];

    /* Valid values are:
     *   GrowlVeryLowPriorty
     *   GrowlModeratePriorty
     *   GrowlNormalPriority (Default)
     *   GrowlHighPriority
     *   GrowlEmergencyPriority (Default for growlErrorWithTitle:description:)
     */
    [myGrowl setPriority:GrowlNormalPriority];

    [myGrowl setSticky:NO]; // Default: NO


Then you can display your Growl using one of two ways, depending on if you care
about user input or not:

    /* Either fire and forget with no user callback. */
    [Growler growl:myGrowl];

    /* Or call the given block when the Growl disappears or is clicked. */
    [Growler growl:myGrowl
         withBlock:^(GrowlerGrowlAction action) {
             if (action == GrowlerGrowlClicked) {
                 [myObject doSomethingInResponseToClick];
             } else if (action == GrowlerGrowlIgnored) {
                 [myObject cancelOperation];
             }
         }];


Use one of those two approaches, not both.

[1]: http://growl.info/documentation/developer/implementing-growl.php "Implementing Growl"
