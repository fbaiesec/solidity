// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";                  ///地址
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";   
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/f88e555234/contracts/utils/structs/EnumerableSet.sol";

/*
 * 发行一个nft合约里面的nft，是可以归属于不同的class的
 * 把classId等同于nft就可以了呀哈哈哈
 */
contract ClassMetadata{
    using Address for address;
    using Strings for uint256;

    // classid
    struct class {
        uint256 _classId;
        bool _transferable;
        bool _burnable;
        bool _mintable;
        bool _frozen;
    }
    // // class owner
    // address public _owner;  ///该class的拥有者
    /// 已经存在的classid个数
    uint256 public _registerCount;
    // class owners
    mapping(uint256 => class) private _class;        ///class的拥有者，注册时就新增一个
    mapping(uint256 => address) private _owners;
    ///classId => tokenId
    mapping(uint256 => EnumerableSet.UintSet) private _classes;       ///一对多，查询某class下的所有tokenId
    ///tokenId => classId
    mapping(uint256 => uint256) private _tokenIdClass;  ///多对多，查询tokenId所属class
    
    constructor() {
       _registerCount = 0;
    }
    function getCount() public view returns (uint256) {
        return _registerCount;
    }
    /*
     * register class
     */
    function register(address to, bool transferable,bool burnable,bool mintable,bool frozen) public {
        require(to != address(0), "ERC721: mint to the zero address");

        _registerCount += 1;
        class memory __class = class({
            _classId : _registerCount,
            _transferable : transferable,
            _burnable : burnable,
            _mintable : mintable,
            _frozen : frozen
        });
        _class[_registerCount] = __class;
        _owners[_registerCount] = to;
    }

    ///对class属性的设置
    function getTransferable(uint256 classId) public view returns (bool){
        return _class[classId]._transferable;
    }
    function setTransferable(uint256 classId,bool transferable) public {
        ///只有class所有者才可以进行设置
        address owner = _owners[classId];
        require(msg.sender == owner,"only owner can set class");
       
        _class[classId]._transferable = transferable;
    }
        function getBurnable(uint256 classId) public view returns (bool){
        return _class[classId]._burnable;
    }
    function setBurnable(uint256 classId,bool burnable) public {
        ///只有class所有者才可以进行设置
        address owner = _owners[classId];
        require(msg.sender == owner,"only owner can set class");
       
        _class[classId]._burnable = burnable;
    }
    function getMintable(uint256 classId) public view returns (bool){
        return _class[classId]._mintable;
    }
    function setMintable(uint256 classId,bool mintable) public {
        ///只有class所有者才可以进行设置
        address owner = _owners[classId];
        require(msg.sender == owner,"only owner can set class");
       
        _class[classId]._mintable = mintable;
    }
    function getFrozen(uint256 classId) public view returns (bool){
        return _class[classId]._transferable;
    }
    function setFrozen(uint256 classId,bool frozen) public {
        ///只有class所有者才可以进行设置
        address owner = _owners[classId];
        require(msg.sender == owner,"only owner can set class");
       
        _class[classId]._frozen = frozen;
    }
     ///为nft设置classId和移除
    function addClassForNft(uint256 tokenId,uint256 classId) public {
        ///只有class所有者才可以进行设置
        address owner = _owners[classId];
        require(msg.sender == owner,"only owner can set class");
        ///一个tokenId只能有一个classId
        require(_tokenIdClass[tokenId] == 0,"tokenId is assigned classId");
        
        EnumerableSet.add(_classes[classId],tokenId);
        _tokenIdClass[tokenId] = classId;
    }
     function getOwner(uint256 classId) public view returns (address){
        return _owners[classId];
    }
}
