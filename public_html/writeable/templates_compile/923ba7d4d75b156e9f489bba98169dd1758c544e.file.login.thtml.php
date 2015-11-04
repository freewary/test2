<?php /* Smarty version Smarty-3.0.6, created on 2015-10-16 23:11:11
         compiled from "/var/www/vhosts/example.com/themes/alphamental/account_templates/login.thtml" */ ?>
<?php /*%%SmartyHeaderCode:359742954554a896e521931-18728532%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '923ba7d4d75b156e9f489bba98169dd1758c544e' => 
    array (
      0 => '/var/www/vhosts/example.com/themes/alphamental/account_templates/login.thtml',
      1 => 1429922904,
      2 => 'file',
    ),
    'af760c33310fd2b54df2dd1746ec42685277df28' => 
    array (
      0 => '/var/www/vhosts/example.com/themes/alphamental/layout.thtml',
      1 => 1444790169,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '359742954554a896e521931-18728532',
  'function' => 
  array (
  ),
  'has_nocache_code' => false,
)); /*/%%SmartyHeaderCode%%*/?>
<?php if (!is_callable('smarty_function_url')) include '/var/www/vhosts/example.com/themes/_plugins/function.url.php';
if (!is_callable('smarty_function_setting')) include '/var/www/vhosts/example.com/themes/_plugins/function.setting.php';
if (!is_callable('smarty_function_theme_url')) include '/var/www/vhosts/example.com/themes/_plugins/function.theme_url.php';
if (!is_callable('smarty_block_login_form')) include 'app/modules/users/template_plugins/block.login_form.php';
if (!is_callable('smarty_function_menu')) include 'app/modules/menu_manager/template_plugins/function.menu.php';
if (!is_callable('smarty_block_has_cart')) include 'app/modules/store/template_plugins/block.has_cart.php';
if (!is_callable('smarty_function_cart_items')) include 'app/modules/store/template_plugins/function.cart_items.php';
if (!is_callable('smarty_modifier_date_format')) include '/var/www/vhosts/example.com/app/libraries/smarty/plugins/modifier.date_format.php';
?><!DOCTYPE html>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
<base href="<?php echo smarty_function_url(array(),$_smarty_tpl);?>
" />
<title>
Account Login - <?php echo smarty_function_setting(array('name'=>"site_name"),$_smarty_tpl);?>

</title>

<!-- Add CSS callouts below here -->
<link href="<?php echo smarty_function_theme_url(array('path'=>"css/universal.css"),$_smarty_tpl);?>
" rel="stylesheet" type="text/css" media="screen" />
<link href="<?php echo smarty_function_theme_url(array('path'=>"css/jquery.css"),$_smarty_tpl);?>
" rel="stylesheet" type="text/css" media="screen" />
<link href="<?php echo smarty_function_theme_url(array('path'=>"css/hint.css"),$_smarty_tpl);?>
" rel="stylesheet" type="text/css" media="screen" />
<!-- Add Javascript callouts below here -->
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
<script src="<?php echo smarty_function_theme_url(array('path'=>"js/bsn.AutoSuggest_c_2.0.js"),$_smarty_tpl);?>
" type="text/javascript"></script>
<script src="<?php echo smarty_function_theme_url(array('path'=>"js/alpha-functions.js"),$_smarty_tpl);?>
" type="text/javascript"></script>
  


</head>
<body>
<div id="notices"></div>
<!-- Wrapper starts here -->
<div id="wrapper">
	<!-- Main container starts here -->
	<div class="container">
		<!-- Header starts here -->
		<div id="header">
		<h1>Alphamental</h1>
		
		
		<div id="login-area">
		<?php if (!$_smarty_tpl->getVariable('logged_in')->value){?>
			<div class="side_login">
				<?php $_smarty_tpl->smarty->_tag_stack[] = array('login_form', array('var'=>"form",'return'=>$_smarty_tpl->getVariable('current_url')->value)); $_block_repeat=true; smarty_block_login_form(array('var'=>"form",'return'=>$_smarty_tpl->getVariable('current_url')->value), null, $_smarty_tpl, $_block_repeat);while ($_block_repeat) { ob_start();?>

					<form method="post" action="<?php echo $_smarty_tpl->getVariable('form')->value['form_action'];?>
">
						<input type="hidden" name="return" value="<?php echo $_smarty_tpl->getVariable('form')->value['return'];?>
">						
						<table class="login-table">
							<tr>
								<td><input class="text" type="text" placeholder="email or username" name="username" value="" /></td>				
								<td><input class="text" type="password" placeholder="password" name="password" value="" /></td>
								<td><input type="submit" class="button small" name="" value="Login Now" /></td>
							</tr>
							<tr>
								<td><a href="<?php echo smarty_function_url(array('path'=>"users/register"),$_smarty_tpl);?>
">Create an account</a></td>
								<td><a href="<?php echo smarty_function_url(array('path'=>"users/forgot_password"),$_smarty_tpl);?>
">I forgot my password</a></td>
							</tr>
						</table>
					</form>					
				<?php $_block_content = ob_get_clean(); $_block_repeat=false; echo smarty_block_login_form(array('var'=>"form",'return'=>$_smarty_tpl->getVariable('current_url')->value), $_block_content, $_smarty_tpl, $_block_repeat);  } array_pop($_smarty_tpl->smarty->_tag_stack);?>

			</div>
		<?php }else{ ?>
			<div class="user-info">
			<p class="user-name">Welcome, <?php echo $_smarty_tpl->getVariable('member')->value['first_name'];?>
</p>
			<div class="user-menu-icons"><img src="<?php echo smarty_function_theme_url(array('path'=>"images/photo.png"),$_smarty_tpl);?>
" class="user-menu-avatar"/></div>
			</div>
			<div class="user-menu">
				<div class="user-menu-pointy-thingy">
					
					
				</div>
				<div class="user-menu-content">
					<p class="account_links">
						<!-- <img src="<?php echo smarty_function_theme_url(array('path'=>"images/manage_account.png"),$_smarty_tpl);?>
" alt="manage account" /> --> <a class="side_manage" href="<?php echo smarty_function_url(array('path'=>"users"),$_smarty_tpl);?>
">Manage my account</a>
						<!-- <img src="<?php echo smarty_function_theme_url(array('path'=>"images/logout.png"),$_smarty_tpl);?>
" alt="logout" /> --> <a class="side_logout" href="<?php echo smarty_function_url(array('path'=>"users/logout"),$_smarty_tpl);?>
">Logout</a>
					</p>
				</div>
			</div>
		<?php }?>
		</div>
		
		
		
		<div style="clear:both;"></div>
		
		
		</div>			
		<!-- Header ends here -->
		
		<div id="navigation">
			<?php echo smarty_function_menu(array('name'=>"main_menu",'show_sub_menus'=>"yes"),$_smarty_tpl);?>

			<div style="clear:both"></div>
		</div>
		
		
			
		<div class="container content">
		
		<!-- Sidebar starts here -->
		
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
						
					</div>
					<div class="sidebar_foot"></div>
				</div>
				
				<?php if ($_smarty_tpl->getVariable('uri_segment')->value[1]!="events"){?>
					<div class="sidebar_block">
						<div class="sidebar_head"></div>
						<div class="sidebar_body">
							
						</div>
						<div class="sidebar_foot"></div>
					</div>
				<?php }?>
				
				<div class="sidebar_block">
					<div class="sidebar_head"></div>
					<div class="sidebar_body">
						
					</div>
					<div class="sidebar_foot"></div>
				</div>
			</div>
		
		<!-- Sidebar ends here -->
		
		<!-- Main content starts here -->
		<div class="inner_content">
		
	<?php $_smarty_tpl->smarty->_tag_stack[] = array('login_form', array('var'=>"login",'return'=>$_smarty_tpl->getVariable('return')->value,'username'=>$_smarty_tpl->getVariable('username')->value)); $_block_repeat=true; smarty_block_login_form(array('var'=>"login",'return'=>$_smarty_tpl->getVariable('return')->value,'username'=>$_smarty_tpl->getVariable('username')->value), null, $_smarty_tpl, $_block_repeat);while ($_block_repeat) { ob_start();?>

		<h1>Account Login</h1>
		<form class="form validate" method="post" action="<?php echo $_smarty_tpl->getVariable('login')->value['form_action'];?>
">
			<input type="hidden" name="return" value="<?php echo $_smarty_tpl->getVariable('login')->value['return'];?>
">
			
			<?php if ($_smarty_tpl->getVariable('validation_errors')->value){?>
				<div class="errors">
					<?php echo $_smarty_tpl->getVariable('validation_errors')->value;?>

				</div>
			<?php }?>
			
			<?php if ($_smarty_tpl->getVariable('notices')->value){?>
				<div class="notices">
					<?php echo $_smarty_tpl->getVariable('notices')->value;?>

				</div>
			<?php }?>
		
			<ul class="form">
				<li>
					<label for="username">Username/Email</label>
					<input type="text" class="text required" id="username" name="username" value="<?php echo $_smarty_tpl->getVariable('login')->value['username'];?>
">
				</li>
				<li>
					<label for="password">Password</label>
					<input type="password" class="text required" id="password" name="password" />
				</li>
				<li class="indent">
					<input type="checkbox" value="1" name="remember" /> Remember me for future visits?
				</li>
				<li class="indent">
					<input type="submit" class="button" name="login" value="Login" />
				</li>
			</ul>
			
			<ul class="login_form_links">
				<li>
					<a href="<?php echo smarty_function_url(array('path'=>"users/register"),$_smarty_tpl);?>
">Don't have an account? Click here to register.</a>
				</li>
				<li>
					<a href="<?php echo smarty_function_url(array('path'=>"users/forgot_password"),$_smarty_tpl);?>
">Forgot your password?</a>
				</li>
			</ul>
		</form>
	<?php $_block_content = ob_get_clean(); $_block_repeat=false; echo smarty_block_login_form(array('var'=>"login",'return'=>$_smarty_tpl->getVariable('return')->value,'username'=>$_smarty_tpl->getVariable('username')->value), $_block_content, $_smarty_tpl, $_block_repeat);  } array_pop($_smarty_tpl->smarty->_tag_stack);?>


		</div>
		<!-- Main content ends here -->
		
		<div style="clear:both"></div>
	<!-- Footer starts here -->
	<div class="container footer">
		Copyright &copy; <?php echo smarty_modifier_date_format(time(),"%Y");?>
, <?php echo smarty_function_setting(array('name'=>"site_name"),$_smarty_tpl);?>
.  All Rights Reserved.  &nbsp;&nbsp;&nbsp;<?php echo smarty_function_menu(array('name'=>"footer_menu",'show_sub_menus'=>"off",'class'=>"footer_menu"),$_smarty_tpl);?>

	</div>
	<!-- Footer ends here -->	
	</div>
	
	<!-- Main container ends here -->
</div>
</div>
	<?php if ($_smarty_tpl->getVariable('logged_in')->value){?>
		<div id="idea-bar">
			<div>
			<div id="ticker" class="suggest">
			<div id="ticker-inner" class="suggest-inner"></div>
			</div>
			</div>
			<form class="form validate" enctype="multipart/form-data" method="post" action="<?php echo smarty_function_url(array('path'=>"portfolios/trade/buy"),$_smarty_tpl);?>
">
			<input id="ticker-input" class="symbol" type="text" name="ticker_symbol" placeholder="ticker" onkeyup="showHint(this.value)" autocomplete="off" />
			<input type="text" name="cost_per" />
			<input type="text" name="quantity" placeholder="quantity" />
			<!-- <input type="submit" class="button" name="buy" value="Buy" /> -->
			<button type="submit" class="button" value="Submit">Review</button>
			<button type="reset" class="button" value="Reset">Clear</button>
			</form>
		</div>
	<?php }?>
<!--- Wrapper ends here -->

</body>

<!-- Jquery Main tabs -->
<script>
$(document).ready(function(){
	
	$('ul.main li').click(function(){
		var main_id = $(this).attr('data-tab');

		$('ul.main li').removeClass('current');
		$('.maintab-content').removeClass('current');

		$(this).addClass('current');
		$("#"+main_id).addClass('current');
	})

})
</script>
<!-- Jquery Sub Tabs -->
<script>
$(document).ready(function(){
	
	$('ul.subs li').click(function(){
		var tab_id = $(this).attr('data-tab');

		$('ul.subs li').removeClass('current');
		$('.subtab-content').removeClass('current');

		$(this).addClass('current');
		$("#"+tab_id).addClass('current');
	})

})
</script>
<?php if ($_smarty_tpl->getVariable('logged_in')->value){?>
<script>
function showHint(str) {
    if (str.length == 0) {
        document.getElementById("ticker-inner").innerHTML = "";
		document.getElementById('ticker').style.display = "none";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("ticker-inner").innerHTML = xmlhttp.responseText;
				document.getElementById('ticker').style.display = "block";
				document.getElementById('ticker').style.backgroundColor = "#fff";
            }
        }
        xmlhttp.open("GET", "./portfolios/gethint/" + str, true);
        xmlhttp.send();
    }
}

function hintValue(str2) {
	document.getElementById('ticker-input').value = str2;
	document.getElementById('ticker').style.display = "none";
}
</script>
<?php }?>



</html>