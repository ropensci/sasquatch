# non-existing cfgname throws error

    Code
      sas_connect(cfgname = "some config that doesn't exist")
    Condition
      Error in `sas_connect()`:
      ! `cfgname` must specify an existing configuration.
      x `"some config that doesn't exist" cannot be found.
      i Available configurations include: 

---

    Code
      sas_connect(cfgname = "anotherconfigthatdoesntexist")
    Condition
      Error in `sas_connect()`:
      ! `cfgname` must specify an existing configuration.
      x `"anotherconfigthatdoesntexist" cannot be found.
      i Available configurations include: 

