// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

contract ERC20 {
    /*//////////////////////////////////////////////////////////////
                                 EVENTOS
    //////////////////////////////////////////////////////////////*/

    event Transferencia(
        address indexed de,
        address indexed para,
        uint256 quantidade
    );

    event Aprovacao(
        address indexed proprietario,
        address indexed gastador,
        uint256 quantidade
    );

    /*//////////////////////////////////////////////////////////////
                            ARMAZENAMENTO DE METADADOS
    //////////////////////////////////////////////////////////////*/

    string public nome;

    string public simbolo;

    uint8 public immutable decimais;

    /*//////////////////////////////////////////////////////////////
                             ARMAZENAMENTO ERC20
    //////////////////////////////////////////////////////////////*/

    uint256 public ofertaTotal;

    mapping(address => uint256) public saldoDe;

    mapping(address => mapping(address => uint256)) public permissao;

    /*//////////////////////////////////////////////////////////////
                            ARMAZENAMENTO EIP-2612
    //////////////////////////////////////////////////////////////*/

    uint256 internal immutable ID_CADEIA_INICIAL;

    bytes32 internal immutable SEPARADOR_DOMINIO_INICIAL;

    mapping(address => uint256) public nonces;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUTOR
    //////////////////////////////////////////////////////////////*/

    address private proprietario;

    constructor(string memory _nome, string memory _simbolo, uint8 _decimais) {
        nome = _nome;
        simbolo = _simbolo;
        decimais = _decimais;
        proprietario = msg.sender;

        ID_CADEIA_INICIAL = block.chainid;
        
        SEPARADOR_DOMINIO_INICIAL = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string nome,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes(_nome)),
                keccak256("1"),
                block.chainid,
                address(this)
            )
        );
    }
    /*//////////////////////////////////////////////////////////////
                        LÓGICA INTERNA DE CRIAÇÃO/QUEIMA
    //////////////////////////////////////////////////////////////*/

    function criar(address para, uint256 quantidade) public {
        require(
            msg.sender == proprietario,
            "Somente o proprietário pode criar tokens"
        );
        ofertaTotal += quantidade;
        saldoDe[para] += quantidade;

        emit Transferencia(address(0), para, quantidade);
    }

    function queimar(address de, uint256 quantidade) public {
        require(
            msg.sender == proprietario,
            "Somente o proprietário pode queimar tokens"
        );
        require(saldoDe[de] >= quantidade, "Saldo insuficiente para queimar");

        saldoDe[de] -= quantidade;
        ofertaTotal -= quantidade;

        emit Transferencia(de, address(0), quantidade);
    }
}
