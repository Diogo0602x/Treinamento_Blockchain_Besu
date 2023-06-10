// SPDX-License-Identifier: MIT
// Endereço do contrato : 0x35EeDE02d52C830353b50c31ae498612029Cd308

pragma solidity 0.8.20;

contract ContratoAluguel {

    address public dono;

    event NomeAlterado(uint8 tipoPessoa, string novoNome);
    event AluguelReajustado(uint256 mes, uint256 aumento);

  string public locador;
  string public locatario;
  uint256[36] public valoresAluguel;

    modifier unicoDono {
      require(msg.sender == dono, "Somente o dono do contrato pode realizar essa operação.");
    }

  constructor(string memory _locador, string memory _locatario, uint256 valorInicialAluguel) {
    locador = _locador;
    locatario = _locatario;
    dono = msg.sender;

    for (uint i = 0; i < 36; i++) {
      valoresAluguel[i] = valorInicialAluguel;
    }
  }

  function valorAluguel(uint256 mes) public view returns (uint256) {
    require(mes > 0 && mes <= 36, "Mês inválido. Insira um valor entre 1 e 36.");
    return valoresAluguel[mes - 1]; 
  }

  function getNomes() public view returns (string memory, string memory) {
    return (locador, locatario);
  }

  function alterarNome(uint8 tipoPessoa, string memory novoNome) public {
    if (tipoPessoa == 1) {
      locador = novoNome;
    } else if (tipoPessoa == 2) {
      locatario = novoNome;
    } else {
      revert("Tipo de pessoa inválido. Use 1 para locador e 2 para locatário.");
    }

    emit NomeAlterado(tipoPessoa, novoNome);
  }

  function reajusteAluguel(uint256 mes, uint256 aumento) public onlyOwner {
    require(mes > 0 && mes <= 36, "Mês inválido. Insira um valor entre 1 e 36.");

    for (uint i = mes; i < 36; i++) {
      valoresAluguel[i] += aumento;
    }

    emit AluguelReajustado(mes, aumento);
  }
}
