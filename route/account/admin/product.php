<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Products</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                    <a href='#addProduct' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-universal-access'></i></span> Create Product</a>
                    <hr/>
                    <table id="productsTable" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>PID</th>
                            <th>Product Name</th>
                            <th>Product Code</th>
                            <th>Product Image</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Status</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myBusinessAccountProductView($account_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['id']."</td>   
                                        <td>".$accounts['name']."</td>
                                        <td>".$accounts['code']."</td>
                                        <td><img src='".$accounts['image']."' style='width:10%;'></td>
                                        <td>".$accounts['price']."</td>
                                        <td>".$accounts['quantity']."</td>
                                        <td>".$accounts['status']."</td>
                                    </tr>";
                                }
                            }
                            ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>