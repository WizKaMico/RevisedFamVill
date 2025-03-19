<?php 

$cartItem = $portCont->getMemberCartItem($client_id);
$item_quantity = 0;
$item_price = 0;
if (! empty($cartItem)) {
    if (! empty($cartItem)) {
        foreach ($cartItem as $item) {
            $item_quantity = $item_quantity + $item["quantity"];
            $item_price = $item_price + ($item["price"] * $item["quantity"]);
        }
    }
}

?>

<div class="row">
    <div class="col-md-8">
        <div class="main-card mb-3 card">
            <div class="card-header">Product</div>
            <div class="container">
                <div class="row flex-column align-items-center">  
                   
                        <div class="col-md-12 mb-3 mt-3 gap-3 d-flex justify-content-center">  
                        <?php
                    $accounts = $portCont->myBusinessAccountProductView($account_id);
                    if (!empty($accounts)) {
                        foreach ($accounts as $key => $accounts) {
                    ?>
                    <form method="post" action="?view=PRODUCTS&action=ADD&code=<?php echo $accounts['code']; ?>">
                        <div class="card" style="width: 18rem;">
                            <img src='../../account/admin/<?php echo $accounts['image']; ?>'>
                                <div class="card-body text-center">
                                    <h5 class="card-title"><?php echo $accounts['name']; ?> | ₱ <?php echo $accounts['price']; ?></h5>
                                    <input type="hidden" name="quantity" value="1" />
                                    <input type="submit" name="submit" value="Add to Cart" class="btn btn-primary w-100">
                                </div>
                        </div>
                    </form>
                    <?php } } ?>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="main-card mb-3 card">
            <div class="card-header">Cart | ₱<?php echo $item_price; ?></div>
            <div class="container">
                <div class="table-responsive">
                    <div class="col-md-12 mt-2">
                        <table id="upcomingTable" class="align-middle mb-0 table table-borderless table-striped table-hover">
                            <thead>
                                <th>PID</th>
                                <th>NAME</th>
                                <th>QTY</th>
                                <th>PRICE</th>
                                <th>ACTION</th>
                            </thead>
                            <tbody>
                            <?php
                                if (!empty($cartItem)) {
                                    foreach ($cartItem as $key => $value) {
                                            echo 
                                            "<tr>
                                                <td>".$value['code']."</td>
                                                <td>".$value['name']."</td>
                                                <td>".$value['quantity']."</td>
                                                <td>".$value['price']."</td>
                                                <td><a href='?view=PRODUCTS&action=remove&id=".$value['cart_id']."' class='btn btn-danger'><span class='fa fa-trash-o'></span></a></td>
                                            </tr>";
                                    }
                                }
                                else
                                {
                                    echo 
                                    "<tr>
                                        <td colspan='5' style='text-align:center;'>Cart Empty</td>
                                    </tr>";
                                }
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>            
            </div>
            <div class="card-footer">
                <center>
                <div class="row">
                    <div class="col-12">
                       <a href="?view=PRODUCTS&action=empty" class='btn btn-danger w-100 mb-2'><span class='fa fa-trash-o'></span> Empty Cart</a>
                    </div>
                    <div class="col-12">
                      <form action="?view=PRODUCTS&action=PAYPRODUCT" method="POST">
                        <input type="hidden" name="item_price" value="<?php echo $item_price; ?>" />
                        <input type="submit" name="submit" value="Order Now" class="btn btn-primary w-100"/>     
                      </form>
                    </div>
                </div>
                </center>
            </div>
        </div>
    </div>                        
</div>
