variable "suts_attributes" {
  description = "The attributes that apply to each specific SUT."  
  type = map(object({
    // Populate with properties as required
    purpleteamlabs_sut_cname = string
  }))
}
