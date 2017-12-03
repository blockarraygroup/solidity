pragma solidity ^0.4.14;

    import "Ownable.sol";

 
contract EthBarcode is Ownable {
    event BarcodeIssued(address recipient, bytes32 barcode);

    struct BarcodeAsset {

            address issuer;
            address recipient;
            uint256 block;

    }


        mapping (bytes32 => BarcodeAsset) barcodes;

    function issueBarcode(address recipient, bytes32 barcode) payable public returns (bool) {
        require(barcodes[barcode].issuer == address(0));

           barcodes[barcode].issuer = msg.sender;
           barcodes[barcode].recipient = recipient;
           barcodes[barcode].block = block.number;

    BarcodeIssued(recipient, barcode);

        return true;


}