{
  # Password provider
  PasswordProvider = {
    type = "enum";
    default = "orionKeychain";
    values = [
      "orionKeychain"
      "thirdParty"
      "none"
    ];
  };

  # Password AutoFill
  AutofillEnabled = {
    type = "bool";
    default = true;
  };
  OfferSavePassword = {
    type = "bool";
    default = true;
  };
  AutoFillSubmitFormAutomatically = {
    type = "bool";
    default = true;
  };
}
