// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract FBlocks {

    /**
  * @dev Define the structure for a basic product
    // Need to define for Stakeholders, Product, TraceNTrack
  */
  struct Stakeholder
  {
    string id;
    string name;
    string description;
    string location;
    string role;
    uint256 inceptionDate;
    uint256 walletShare;
    bool exist;
  }

  struct Product 
  {
    string prodId;
    string prodName;
    string productType;
    string ProdDesc;
    string ProductOrgin;
    string farmerName;
    uint256 salesPrice;
    bool exist;
  }

  struct Traceability 
  {
    string fertilizerInfo;
    string seedOrgin;
    uint256 temperature;
    uint256 humidity;
    uint TruckRunningTime;
    uint256 shelfTime;
  }

  struct ProductStatus 
  {
    string id;
    bool inTrasit;
    bool inSource;
    bool inDestination;    
  }

 /**
  * @dev Mapping that define the storage of a product
  */
  mapping(string  => Product) private ProductStorage;
  mapping(string  => Stakeholder) private stakeholderStorage;
  mapping(string  => ProductStatus) private StatusStorage;
  mapping(string  => Traceability) private TraceStorage;
  mapping(address => mapping(string => bool)) private foodWallet;
   
      /**
  * @dev Declare events according the Food Supply Chain:
  */
  event CreateProduct(address addressProducer, string id, string Producer, uint256 CreationDate);
  event TransferProduct(address fromStakeholder, address toStakeholder, string id);
  event CreateStakeholder(address addressStakeholder, string id, string name, uint256 inceptionDate);
  event StatusChange(string id,address statusDesc,string currentStatus);
  event ActionTraceability( string fertilizerInfo, string seedOrigin, uint32 temperature,uint32 humidity,uint TruckRunningTime,uint shelfTime);
  event setPrice(string id, uint32 salePrice);
  event TransferReject(address from, address to, string id, string RejectMessage);
  event CreationReject(address addressStakeholder, string id, string RejectMessage);

 /**
  * @dev Function that create the Product: Specific product eg., "strawberry"
  */
  function CreateProduct1(address addressProducer, string memory id, string memory Producer, uint256 CreationDate, string memory prodType,string memory desc,uint salesPrice,string memory name) public {
 
    if(ProductStorage[id].exist) {
        emit CreationReject(msg.sender, id, "This product already exists");
        return;
      }
  //    ProductStorage[id] = Product(addressProducer,id,Producer,CreationDate,desc,prodType,name,true);
      //ProductStorage[id] = Product(prodId,prodName,productType,ProdDesc,ProductOrgin,farmerName,salesPrice,true);
      foodWallet[msg.sender][id] = true;
      emit CreateProduct(msg.sender, id, Producer, block.timestamp);
    }

/**
  * @dev Function that makes the transfer of food product from one stakeholder to another
  */
  function TransferProduct1(address toStakeholder, string memory id) public{
 
    if(!ProductStorage[id].exist) {
        emit TransferReject(msg.sender, toStakeholder, id, "No product id exists for this transaction");
        return;
    }
 
    if(!foodWallet[msg.sender][id]) {
        emit TransferReject(msg.sender, toStakeholder, id, "Transaction Rejected and no Wallet transfer");
        return;
    }
 
    foodWallet[msg.sender][id] = false;
    foodWallet[toStakeholder][id] = true;
    emit TransferProduct (msg.sender, toStakeholder, id);
  }

  /**
  * @dev Function that create the Stakeholder: Farmer/Supplier/Distributor/Retailer/Consumer
  */
  function CreateStakeHolders1(address addressStakeholder, string memory id, string memory name, uint256 inceptionDate) public {
 
    if(stakeholderStorage[id].exist) {
        emit CreationReject(msg.sender, id, "The Stakeholder already exists");
        return;
      }
  //  stakeholderStorage[id] = Stakeholder(addressStakeholder, id, name,inceptionDate);
    //stakeholderStorage[id] = Stakeholder(id, name, desc,loc,role,incDate,wShare,true);
      foodWallet[msg.sender][id] = true;
      emit CreateStakeholder(msg.sender, id, name, block.timestamp);
    }

     /**
  * @dev Function that records status change: inTransit / inSource / inDestination
  */
  function StatusChange1(string memory id,string memory statusDesc,string memory currentStatus) public {
 
    if(StatusStorage[id].exist) {
        emit CreationReject(msg.sender, id, "Status already upodated for this ID");
        return;
      }
 
     StatusStorage[id] = StatusChange(id, statusDesc,currentStatus);
      foodWallet[msg.sender][id] = true;
      emit StatusChange(id, statusDesc,currentStatus);
    }

      /**
  * @dev Function that records status change: inTransit / inSource / inDestination
  */
  function ActionTraceability1(string memory id,string memory fertilizerInfo, string memory seedOrigin, uint32 temperature,uint32 humidity,uint TruckRunningTime,uint shelfTime) public {
 
    if(TraceStorage[id].exist) {
        emit CreationReject(msg.sender, id, "Tracking details already avaiable for this ID");
        return;
      }
 
     TraceStorage[id] = ActionTraceability(id,fertilizerInfo, seedOrigin, temperature,humidity,TruckRunningTime,shelfTime);
      foodWallet[msg.sender][id] = true;
      emit ActionTraceability(id,fertilizerInfo, seedOrigin, temperature,humidity,TruckRunningTime,shelfTime);
    }
    
}
