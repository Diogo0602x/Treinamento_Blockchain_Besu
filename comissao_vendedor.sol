// SPDX-License-Identifier: MIT
// Endereço do contrato : 0x304B05e23c4ba9F324b4C830F3bF02C9BEe62221

pragma solidity 0.8.20;

contract ComissaoVendedor {

    // Estrutura para armazenar os dados do vendedor
    struct Vendedor {
        string nome;
        uint256 valorVenda;
        uint256 fatorBonus;
    }

    // Mapeamento para armazenar vendedores pelo endereço Ethereum
    mapping(address => Vendedor) public vendedores;

    // Função para definir as variáveis
    function setDados(string memory _nome, uint256 _valorVenda, uint256 _fatorBonus) public {
        // Armazenar as informações do vendedor no mapeamento
        vendedores[msg.sender] = Vendedor(_nome, _valorVenda, _fatorBonus);
    }

    // Função que calcula o bônus do vendedor
    function calculoBonus(address vendedorAddress) public view returns (uint256) {
        // Verificar se o vendedor existe
        require(bytes(vendedores[vendedorAddress].nome).length > 0, "Vendedor não existe!");

        // Calcular o bônus
        uint256 bonus = vendedores[vendedorAddress].valorVenda * vendedores[vendedorAddress].fatorBonus / 100;
        return bonus;
    }
}
