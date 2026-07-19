{
  # Password provider
  PasswordProvider = {
    default = "orionKeychain";
    values = [
      "orionKeychain"
      "thirdParty"
      "none"
    ];
  };

  # Password AutoFill
  AutofillEnabled.default = true;
  OfferSavePassword.default = true;
  AutoFillSubmitFormAutomatically.default = true;
}
