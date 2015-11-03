<?php /* Smarty version Smarty-3.0.6, created on 2015-04-25 01:26:34
         compiled from "/var/www/vhosts/example.com/themes/electric/store_product.thtml" */ ?>
<?php /*%%SmartyHeaderCode:1599239294553aed4a4b0e42-36354756%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'ac435677e6d89113c12022dd20de31ef7f9d0257' => 
    array (
      0 => '/var/www/vhosts/example.com/themes/electric/store_product.thtml',
      1 => 1429922904,
      2 => 'file',
    ),
    '08236fec618a9f088c857e529dd1664caa9b9c4d' => 
    array (
      0 => '/var/www/vhosts/example.com/themes/electric/layout.thtml',
      1 => 1429922904,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '1599239294553aed4a4b0e42-36354756',
  'function' => 
  array (
  ),
  'has_nocache_code' => false,
)); /*/%%SmartyHeaderCode%%*/?>
<?php if (!is_callable('smarty_function_url')) include '/var/www/vhosts/example.com/themes/_plugins/function.url.php';
if (!is_callable('smarty_function_setting')) include '/var/www/vhosts/example.com/themes/_plugins/function.setting.php';
if (!is_callable('smarty_function_theme_url')) include '/var/www/vhosts/example.com/themes/_plugins/function.theme_url.php';
if (!is_callable('smarty_function_menu')) include 'app/modules/menu_manager/template_plugins/function.menu.php';
if (!is_callable('smarty_block_has_cart')) include 'app/modules/store/template_plugins/block.has_cart.php';
if (!is_callable('smarty_function_cart_items')) include 'app/modules/store/template_plugins/function.cart_items.php';
if (!is_callable('smarty_block_login_form')) include 'app/modules/users/template_plugins/block.login_form.php';
if (!is_callable('smarty_block_content')) include 'app/modules/publish/template_plugins/block.content.php';
if (!is_callable('smarty_modifier_date_format')) include '/var/www/vhosts/example.com/app/libraries/smarty/plugins/modifier.date_format.php';
if (!is_callable('smarty_function_thumbnail')) include '/var/www/vhosts/example.com/themes/_plugins/function.thumbnail.php';
if (!is_callable('smarty_function_money_format')) include '/var/www/vhosts/example.com/themes/_plugins/function.money_format.php';
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
<base href="<?php echo smarty_function_url(array(),$_smarty_tpl);?>
" />
<title>
<?php echo $_smarty_tpl->getVariable('name')->value;?>
 - <?php echo smarty_function_setting(array('name'=>"site_name"),$_smarty_tpl);?>

</title>
<link href='http://fonts.googleapis.com/css?family=Podkova' rel='stylesheet' type='text/css'>
<link href="<?php echo smarty_function_theme_url(array('path'=>"css/universal.css"),$_smarty_tpl);?>
" rel="stylesheet" type="text/css" media="screen" />
<script type="text/javascript" src="<?php echo smarty_function_url(array('path'=>"themes/_common/jquery-1.4.2.min.js"),$_smarty_tpl);?>
"></script>
<script type="text/javascript" src="<?php echo smarty_function_theme_url(array('path'=>"js/universal.js"),$_smarty_tpl);?>
"></script>
<script type="text/javascript" src="<?php echo smarty_function_theme_url(array('path'=>"js/form.js"),$_smarty_tpl);?>
"></script>

	<link rel="stylesheet" type="text/css" href="<?php echo smarty_function_url(array('path'=>"themes/_common/shadowbox/shadowbox.css"),$_smarty_tpl);?>
" />
	<script type="text/javascript" src="<?php echo smarty_function_url(array('path'=>"themes/_common/shadowbox/shadowbox.js"),$_smarty_tpl);?>
"></script>
	<script type="text/javascript">
		Shadowbox.init();
	</script>
	


</head>
<body>
<div id="notices"></div>

<div id="wrapper">
	<div class="container">
		<div id="header">
			<a class="logo" href="<?php echo smarty_function_url(array(),$_smarty_tpl);?>
">
				<div class="logo_text">
					<?php echo smarty_function_setting(array('name'=>"site_name"),$_smarty_tpl);?>

				</div>
			</a>
		</div>
		
		<div id="navigation">
			<?php echo smarty_function_menu(array('name'=>"main_menu",'show_sub_menus'=>"yes"),$_smarty_tpl);?>

			<div style="clear:both"></div>
		</div>
	</div>
		
	<div class="container content">
		
			<div class="sidebar">
				
				
				
			
				
					<?php $_smarty_tpl->smarty->_tag_stack[] = array('has_cart', array()); $_block_repeat=true; smarty_block_has_cart(array(), null, $_smarty_tpl, $_block_repeat);while ($_block_repeat) { ob_start();?>

						<div class="sidebar_block">
							<div class="sidebar_head"></div>
							<div class="sidebar_body">
								<p><a href="<?php echo smarty_function_url(array('path'=>"store/cart"),$_smarty_tpl);?>
">You have <?php echo smarty_function_cart_items(array(),$_smarty_tpl);?>
 item(s) in your shopping cart</a>.</p>
							</div>
							<div class="sidebar_foot"></div>
						</div>
					<?php $_block_content = ob_get_clean(); $_block_repeat=false; echo smarty_block_has_cart(array(), $_block_content, $_smarty_tpl, $_block_repeat);  } array_pop($_smarty_tpl->smarty->_tag_stack);?>

				
			
				<div class="sidebar_block">
					<div class="sidebar_head"></div>
					<div class="sidebar_body">
						<form method="get" action="<?php echo smarty_function_url(array('path'=>"search"),$_smarty_tpl);?>
" class="validate search">
							<label style="display: none" for="side_search">Search Query</label>
							<input type="text" class="text required" placeholder="search query" name="q" id="side_search" /> <input type="submit" class="button small" name="" value="Search" />
						</form>
					</div>
					<div class="sidebar_foot"></div>
				</div>
				
				<div class="sidebar_block">
					<div class="sidebar_head"></div>
					<div class="sidebar_body">
						<?php if (!$_smarty_tpl->getVariable('logged_in')->value){?>
							<h3>Member Login</h3>
							<div class="side_login">
								<?php $_smarty_tpl->smarty->_tag_stack[] = array('login_form', array('var'=>"form",'return'=>$_smarty_tpl->getVariable('current_url')->value)); $_block_repeat=true; smarty_block_login_form(array('var'=>"form",'return'=>$_smarty_tpl->getVariable('current_url')->value), null, $_smarty_tpl, $_block_repeat);while ($_block_repeat) { ob_start();?>

									<form method="post" action="<?php echo $_smarty_tpl->getVariable('form')->value['form_action'];?>
">
										<input type="hidden" name="return" value="<?php echo $_smarty_tpl->getVariable('form')->value['return'];?>
">
										
										<input class="text" type="text" placeholder="email" name="username" value="" /><br />
										<input class="text" type="password" placeholder="password" name="password" value="" /><br />
										<input type="submit" class="button small" name="" value="Login Now" />
									</form>
									<p><a href="<?php echo smarty_function_url(array('path'=>"users/register"),$_smarty_tpl);?>
">Create an account</a></p>
									<p><a href="<?php echo smarty_function_url(array('path'=>"users/forgot_password"),$_smarty_tpl);?>
">I forgot my password</a></p>
								<?php $_block_content = ob_get_clean(); $_block_repeat=false; echo smarty_block_login_form(array('var'=>"form",'return'=>$_smarty_tpl->getVariable('current_url')->value), $_block_content, $_smarty_tpl, $_block_repeat);  } array_pop($_smarty_tpl->smarty->_tag_stack);?>

							</div>
						<?php }else{ ?>
							<h3>My Account</h3>
							<p>Welcome, <?php echo $_smarty_tpl->getVariable('member')->value['first_name'];?>
!</p>
							<p class="account_links"><img src="<?php echo smarty_function_theme_url(array('path'=>"images/manage_account.png"),$_smarty_tpl);?>
" alt="manage account" /> <a class="side_manage" href="<?php echo smarty_function_url(array('path'=>"users"),$_smarty_tpl);?>
">Manage my account</a>&nbsp;&nbsp; <img src="<?php echo smarty_function_theme_url(array('path'=>"images/logout.png"),$_smarty_tpl);?>
" alt="logout" /> <a class="side_logout" href="<?php echo smarty_function_url(array('path'=>"users/logout"),$_smarty_tpl);?>
">Logout</a></p>
						<?php }?>
					</div>
					<div class="sidebar_foot"></div>
				</div>
				
				<?php if ($_smarty_tpl->getVariable('uri_segment')->value[1]!="events"){?>
					<div class="sidebar_block">
						<div class="sidebar_head"></div>
						<div class="sidebar_body">
							<h3>Upcoming Events</h3>
							<ul class="upcoming_events">
							<?php $_smarty_tpl->smarty->_tag_stack[] = array('content', array('var'=>"event",'type'=>"events",'limit'=>"4",'sort'=>"events.event_date",'sort_dir'=>"asc")); $_block_repeat=true; smarty_block_content(array('var'=>"event",'type'=>"events",'limit'=>"4",'sort'=>"events.event_date",'sort_dir'=>"asc"), null, $_smarty_tpl, $_block_repeat);while ($_block_repeat) { ob_start();?>

								<li>
									<a class="name" href="<?php echo $_smarty_tpl->getVariable('event')->value['url'];?>
"><?php echo $_smarty_tpl->getVariable('event')->value['title'];?>
</a>
									<span class="date_place"><?php echo smarty_modifier_date_format($_smarty_tpl->getVariable('event')->value['event_date'],"%e.%b.%Y");?>
 @ <?php echo $_smarty_tpl->getVariable('event')->value['location'];?>
</span>
								</li>
							<?php $_block_content = ob_get_clean(); $_block_repeat=false; echo smarty_block_content(array('var'=>"event",'type'=>"events",'limit'=>"4",'sort'=>"events.event_date",'sort_dir'=>"asc"), $_block_content, $_smarty_tpl, $_block_repeat);  } array_pop($_smarty_tpl->smarty->_tag_stack);?>

							</ul>
						</div>
						<div class="sidebar_foot"></div>
					</div>
				<?php }?>
				
				<div class="sidebar_block">
					<div class="sidebar_head"></div>
					<div class="sidebar_body">
						<h3>Latest Blog Posts</h3>
						<ul class="latest_blog_posts">
						<?php $_smarty_tpl->smarty->_tag_stack[] = array('content', array('var'=>"post",'type'=>"blog",'limit'=>"5",'sort'=>"content.content_date",'sort_dir'=>"desc")); $_block_repeat=true; smarty_block_content(array('var'=>"post",'type'=>"blog",'limit'=>"5",'sort'=>"content.content_date",'sort_dir'=>"desc"), null, $_smarty_tpl, $_block_repeat);while ($_block_repeat) { ob_start();?>

							<li>
								<a class="title" href="<?php echo $_smarty_tpl->getVariable('post')->value['url'];?>
"><?php echo $_smarty_tpl->getVariable('post')->value['title'];?>
</a>
								<span class="date"><?php echo smarty_modifier_date_format($_smarty_tpl->getVariable('post')->value['date'],"%e.%b.%Y");?>
</span>
							</li>
						<?php $_block_content = ob_get_clean(); $_block_repeat=false; echo smarty_block_content(array('var'=>"post",'type'=>"blog",'limit'=>"5",'sort'=>"content.content_date",'sort_dir'=>"desc"), $_block_content, $_smarty_tpl, $_block_repeat);  } array_pop($_smarty_tpl->smarty->_tag_stack);?>

						</ul>
					</div>
					<div class="sidebar_foot"></div>
				</div>
			</div>
		
		
		<div class="inner_content">
			
	<h1><?php echo $_smarty_tpl->getVariable('name')->value;?>
</h1>
	
	<div class="product">
		<div class="bar">
			<?php if ($_smarty_tpl->getVariable('images')->value){?>
				<div class="images">
					<a rel="shadowbox[product_images]" href="<?php echo $_smarty_tpl->getVariable('feature_image_url')->value;?>
" class="feature_image"><img src="<?php echo smarty_function_thumbnail(array('path'=>$_smarty_tpl->getVariable('feature_image')->value,'width'=>"165"),$_smarty_tpl);?>
" alt="<?php echo $_smarty_tpl->getVariable('name')->value;?>
" /></a>
					<ul>
						<?php  $_smarty_tpl->tpl_vars['image'] = new Smarty_Variable;
 $_from = $_smarty_tpl->getVariable('images')->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
if ($_smarty_tpl->_count($_from) > 0){
    foreach ($_from as $_smarty_tpl->tpl_vars['image']->key => $_smarty_tpl->tpl_vars['image']->value){
?>
							<?php if ($_smarty_tpl->tpl_vars['image']->value['path']!=$_smarty_tpl->getVariable('feature_image')->value){?>
								<?php $_smarty_tpl->tpl_vars["image_id"] = new Smarty_variable($_smarty_tpl->tpl_vars['image']->value['id'], null, null);?>
								<li><a rel="shadowbox[product_images]" href="<?php echo $_smarty_tpl->tpl_vars['image']->value['url'];?>
"><img src="<?php echo smarty_function_thumbnail(array('path'=>$_smarty_tpl->tpl_vars['image']->value['path'],'height'=>"50",'width'=>"50"),$_smarty_tpl);?>
" alt="click to enlarge" title="click to enlarge" /></a>
							<?php }?>
						<?php }} ?>
					</ul>
					<div style="clear:both"></div>
				</div>
			<?php }?>
		
			<div class="cart_form">
				<?php if ($_smarty_tpl->getVariable('track_inventory')->value&&!$_smarty_tpl->getVariable('inventory_allow_oversell')->value&&$_smarty_tpl->getVariable('inventory')->value<1){?>
					<p>Unfortunately, this product is sold out.  Please check back again later.</p>
				<?php }else{ ?>
					<span class="price"><?php echo smarty_function_setting(array('name'=>"currency_symbol"),$_smarty_tpl);?>
<?php echo $_smarty_tpl->getVariable('price')->value;?>
</span>
					
					<form method="post" action="<?php echo smarty_function_url(array('path'=>"store/add_to_cart"),$_smarty_tpl);?>
">
						<input type="hidden" name="product_id" value="<?php echo $_smarty_tpl->getVariable('id')->value;?>
" />
						
						<?php if ($_smarty_tpl->getVariable('options')->value){?>
							<ul class="options">
							<?php  $_smarty_tpl->tpl_vars['option'] = new Smarty_Variable;
 $_from = $_smarty_tpl->getVariable('options')->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
if ($_smarty_tpl->_count($_from) > 0){
    foreach ($_from as $_smarty_tpl->tpl_vars['option']->key => $_smarty_tpl->tpl_vars['option']->value){
?>
								<li>
									<label><?php echo $_smarty_tpl->getVariable('product_options')->value[$_smarty_tpl->tpl_vars['option']->value]['name'];?>
</label>
									<select name="option_<?php echo $_smarty_tpl->tpl_vars['option']->value;?>
">
										<?php if ($_smarty_tpl->getVariable('product_options')->value[$_smarty_tpl->tpl_vars['option']->value]['options']){?>
											<?php  $_smarty_tpl->tpl_vars['value'] = new Smarty_Variable;
 $_from = $_smarty_tpl->getVariable('product_options')->value[$_smarty_tpl->tpl_vars['option']->value]['options']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
if ($_smarty_tpl->_count($_from) > 0){
    foreach ($_from as $_smarty_tpl->tpl_vars['value']->key => $_smarty_tpl->tpl_vars['value']->value){
?>
												<option value="<?php echo $_smarty_tpl->tpl_vars['value']->value['label'];?>
"><?php echo $_smarty_tpl->tpl_vars['value']->value['label'];?>
<?php if ($_smarty_tpl->tpl_vars['value']->value['price']!="0"){?> (<?php echo smarty_function_setting(array('name'=>"currency_symbol"),$_smarty_tpl);?>
<?php echo smarty_function_money_format(array('value'=>$_smarty_tpl->tpl_vars['value']->value['price']),$_smarty_tpl);?>
)<?php }?></option>
											<?php }} ?>
										<?php }?>
									</select>
								</li>
							<?php }} ?>
							</ul>
						<?php }?>
						
						<p>Quantity: <input type="text" style="width: 40px" name="quantity" value="1" /></p>
						
						<input type="submit" class="button" name="add_to_cart" value="Add to Cart" />
					</form>
				<?php }?>
			</div>
		</div>
		
		<div class="description">
			<?php echo $_smarty_tpl->getVariable('description')->value;?>

		</div>
	</div>

		</div>
		
		<div style="clear:both"></div>
	</div>
	
	<div class="container footer">
		Copyright &copy; <?php echo smarty_modifier_date_format(time(),"%Y");?>
, <?php echo smarty_function_setting(array('name'=>"site_name"),$_smarty_tpl);?>
.  All Rights Reserved.  &nbsp;&nbsp;&nbsp;<?php echo smarty_function_menu(array('name'=>"footer_menu",'show_sub_menus'=>"off",'class'=>"footer_menu"),$_smarty_tpl);?>

	</div>
</div>
</body>
</html>