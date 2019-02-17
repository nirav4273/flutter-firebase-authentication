

String isRequired(String val,String fieldName){
  if(val == null || val ==''){
    return "$fieldName is required";
  }
  return null;
}

String checkPasswordLength(String val){
  if(val.length < 6){
    return 'Password must be 6 digit';
  }
  return null;
}



String checkFieldValidation(String val,String fieldName,String fieldType){
  String errorMsg = null;
  switch(fieldType){
    case 'text':{
      errorMsg = isRequired(val, fieldName);
      break;
    }
    case 'email':{
      if(isRequired(val, fieldName) != null){
        errorMsg = isRequired(val, fieldName);
      }
      break;
    }
    case 'password':{
      if(isRequired(val, fieldName) != null){
        errorMsg = isRequired(val, fieldName);
      }else if(checkPasswordLength(val) != null){
        errorMsg = checkPasswordLength(val);
      }
    }
  }
  return errorMsg;
}