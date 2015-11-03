<?php /* Smarty version Smarty-3.0.6, created on 2015-04-25 01:26:27
         compiled from "/var/www/vhosts/example.com/themes/electric/store_listing.thtml" */ ?>
<?php /*%%SmartyHeaderCode:1844190143553aed4328faf6-19434252%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '22249c15be0844c3b09e5c36e9a163b46a520f6c' => 
    array (
      0 => '/var/www/vhosts/example.com/themes/electric/store_listing.thtml',
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
  'nocache_hash' => '1844190143553aed4328faf6-19434252',
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
if (!is_callable('smarty_function_shorten')) include '/var/www/vhosts/example.com/themes/_plugins/function.shorten.php';
if (!is_callable('smarty_function_paginate')) include '/var/www/vhosts/example.com/themes/_plugins/function.paginate.php';
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
<base href="<?php echo smarty_function_url(array(),$_smarty_tpl);?>
" />
<title>
<?php if ($_smarty_tpl->getVariable('title')->value){?><?php echo $_smarty_tpl->getVariable('title')->value;?>
<?php }elseif($_smarty_tpl->getVariable('collection')->value){?><?php echo $_smarty_tpl->getVariable('collection')->value['name'];?>
<?php }?> - <?php echo smarty_function_setting(array('name'=>"site_name"),$_smarty_tpl);?>

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
				
	<div class="sidebar_block">
		<div class="sidebar_head"></div>
		<div class="sidebar_body">
			<h3>Our Store Promise</h3>
			<p>We'll delivery only the freshest fruit to your door, any day of the week!  If you don't like it, we'll refund you + 10%.</p>
		</div>
		<div class="sidebar_foot"></div>
	</div>

			
				
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
			
	<h1>Browse Our Store</h1>
	
	<div class="store">
		<?php if ($_smarty_tpl->getVariable('collections')->value){?>
			<ul class="collections">
			<?php  $_smarty_tpl->tpl_vars['collection'] = new Smarty_Variable;
 $_from = $_smarty_tpl->getVariable('collections')->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
if ($_smarty_tpl->_count($_from) > 0){
    foreach ($_from as $_smarty_tpl->tpl_vars['collection']->key => $_smarty_tpl->tpl_vars['collection']->value){
?>
				<li>
					<a class="image" href="<?php echo $_smarty_tpl->tpl_vars['collection']->value['url'];?>
"><img src="<?php echo smarty_function_thumbnail(array('path'=>$_smarty_tpl->tpl_vars['collection']->value['image'],'width'=>"50",'height'=>"50"),$_smarty_tpl);?>
" alt="<?php echo $_smarty_tpl->tpl_vars['collection']->value['name'];?>
" /></a>
					<a class="name" href="<?php echo $_smarty_tpl->tpl_vars['collection']->value['url'];?>
"><?php echo $_smarty_tpl->tpl_vars['collection']->value['name'];?>
</a>
					<?php if ($_smarty_tpl->tpl_vars['collection']->value['description']){?><div class="description"><?php echo $_smarty_tpl->tpl_vars['collection']->value['description'];?>
</div><?php }?>
				</li>
			<?php }} ?>
			</ul>
		<?php }else{ ?>
			<a class="back_button" href="<?php echo smarty_function_url(array('path'=>"store"),$_smarty_tpl);?>
" style="width: 120px; margin-bottom: 15px;">back to store categories</a>
		<?php }?>
		
		<?php if ($_smarty_tpl->getVariable('products')->value){?>
			<ul class="products <?php if ($_smarty_tpl->getVariable('collections')->value){?>with_collections<?php }?>">
			<?php  $_smarty_tpl->tpl_vars['product'] = new Smarty_Variable;
 $_from = $_smarty_tpl->getVariable('products')->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
if ($_smarty_tpl->_count($_from) > 0){
    foreach ($_from as $_smarty_tpl->tpl_vars['product']->key => $_smarty_tpl->tpl_vars['product']->value){
?>
				<li>
					<?php if ($_smarty_tpl->tpl_vars['product']->value['feature_image']){?>
						<a class="image" href="<?php echo $_smarty_tpl->tpl_vars['product']->value['url'];?>
"><img src="<?php echo smarty_function_thumbnail(array('path'=>$_smarty_tpl->tpl_vars['product']->value['feature_image'],'width'=>"110",'height'=>"110"),$_smarty_tpl);?>
" alt="<?php echo $_smarty_tpl->tpl_vars['product']->value['name'];?>
" /></a>
					<?php }?>
					<div class="details">
						<a class="name" href="<?php echo $_smarty_tpl->tpl_vars['product']->value['url'];?>
"><?php echo $_smarty_tpl->tpl_vars['product']->value['name'];?>
</a>
						<div class="price"><?php echo smarty_function_setting(array('name'=>"currency_symbol"),$_smarty_tpl);?>
<?php echo $_smarty_tpl->tpl_vars['product']->value['price'];?>
</div>
						<div class="description"><?php echo smarty_function_shorten(array('string'=>$_smarty_tpl->tpl_vars['product']->value['description'],'length'=>"250"),$_smarty_tpl);?>
</div>
					</div>
				</li>
			<?php }} ?>
			</ul>
			
			<div style="clear:both">
				<?php echo smarty_function_paginate(array('variable'=>"page",'base_url'=>$_smarty_tpl->getVariable('current_url')->value,'total_rows'=>$_smarty_tpl->getVariable('total_products')->value,'per_page'=>$_smarty_tpl->getVariable('products_per_page')->value),$_smarty_tpl);?>

			</div>
		<?php }?>
	</div>
	
	<?php if (!$_smarty_tpl->getVariable('collections')->value&&!$_smarty_tpl->getVariable('products')->value){?>
	<p>This collection is empty.  Add some categories and/or products to populate this page.</p>
	<?php }?>

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