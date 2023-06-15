// SPDX-License-Identifier: MIT
// Endereço do contrato : 0xd9145CCE52D386f254917e481eB44e9943F39138

pragma solidity 0.8.20;

contract ContratoAluguel {

  address public dono;

  event NomeAlterado(uint8 tipoPessoa, string novoNome);
  event AluguelReajustado(uint256 mes, uint256 valorAntigo, uint256 valorNovo);

  struct Pessoa {
    string nome;
    bool isValid;
  }

  Pessoa public locador;
  Pessoa public locatario;
  uint256[36] public valoresAluguel;

  modifier isDono {
    require(msg.sender == dono, "Somente o dono do contrato pode realizar essa operação.");
    _;
  }

  constructor(string memory _nomeLocador, string memory _nomeLocatario, uint256 valorInicialAluguel) {
    locador = Pessoa({nome: _nomeLocador, isValid: true});
    locatario = Pessoa({nome: _nomeLocatario, isValid: true});
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
    return (locador.nome, locatario.nome);
  }

  function alterarNome(uint8 tipoPessoa, string memory novoNome) public isDono {
    require(bytes(novoNome).length != 0, "Nome não pode estar vazio");
    require(tipoPessoa == 1 || tipoPessoa == 2, "Tipo de pessoa inválido. Use 1 para locador e 2 para locatário.");

    if (tipoPessoa == 1) {
      locador.nome = novoNome;
    } else {
      locatario.nome = novoNome;
    }

    emit NomeAlterado(tipoPessoa, novoNome);
  }

  function reajustarAluguel(uint256 mesInicial, uint256 valorReajuste) external isDono {
    require(mesInicial > 0 && mesInicial <= 36, "Mês inválido. Insira um valor entre 1 e 36.");
    require(valorReajuste > 0, "Valor do reajuste inválido");

    uint256 indice = mesInicial - 1;
    for (uint256 i = indice; i < 36; i++) {
      uint256 valorAntigo = valoresAluguel[i];
      valoresAluguel[i] += valorReajuste;
      emit AluguelReajustado(i+1, valorAntigo, valoresAluguel[i]);
    }
  }
}
