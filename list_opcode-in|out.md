--- OPCODEs ---

The meaning of the various *intypes* is shown in the following table:

| Type | Description                               | Variable Types Allowed  | Updated At        |
| ---- | ----------------------------------------- | ----------------------- | ----------------- |
| a    | a-rate variable                           | a-rate                  | a-rate            |
| i    | i-rate variable                           | i-rate                  | i-time            |
| j    | optional i-time, defaults to -1           | i-rate, constant        | i-time            |
| k    | k-rate variable                           | k- and i-rate, constant | k-rate            |
| O    | optional k-rate variable, defaults to 0   | k- and i-rate, constant | k-rate            |
| P    | optional k-rate variable, defaults to 1   | k- and i-rate, constant | k-rate            |
| V    | optional k-rate variable, defaults to 0.5 | k- and i-rate, constant | k-rate            |
| J    | optional k-rate variable, defaults to -1  | k- and i-rate, constant | k-rate            |
| K    | k-rate with initialization                | k- and i-rate, constant | i-time and k-rate |
| o    | optional i-time, defaults to 0            | i-rate, constant        | i-time            |
| p    | optional i-time, defaults to 1            | i-rate, constant        | i-time            |
| S    | string variable                           | i-rate string           | i-time            |

Here are the available *outtypes*:

| Type | Description                | Variable Types Allowed | Updated At        |
| ---- | -------------------------- | ---------------------- | ----------------- |
| a    | a-rate variable            | a-rate                 | a-rate            |
| i    | i-rate variable            | i-rate                 | i-time            |
| k    | k-rate variable            | k-rate                 | k-rate            |
| K    | k-rate with initialization | k-rate                 | i-time and k-rate |
