bool isValidCPF(String cpf) {
  // Removendo caracteres não numéricos
  cpf = cpf.replaceAll(RegExp(r'\D'), '');

  // Verificando se o CPF tem 11 dígitos
  if (cpf.length != 11) {
    return false;
  }

  // Verificando se todos os dígitos são iguais (CPF inválido)
  if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) {
    return false;
  }

  // Calculando o primeiro dígito verificador
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += int.parse(cpf[i]) * (10 - i);
  }
  int remainder = sum % 11;
  int firstDigit = (remainder < 2) ? 0 : (11 - remainder);

  // Verificando o primeiro dígito verificador
  if (int.parse(cpf[9]) != firstDigit) {
    return false;
  }

  // Calculando o segundo dígito verificador
  sum = 0;
  for (int i = 0; i < 10; i++) {
    sum += int.parse(cpf[i]) * (11 - i);
  }
  remainder = sum % 11;
  int secondDigit = (remainder < 2) ? 0 : (11 - remainder);

  // Verificando o segundo dígito verificador
  if (int.parse(cpf[10]) != secondDigit) {
    return false;
  }

  return true;
}