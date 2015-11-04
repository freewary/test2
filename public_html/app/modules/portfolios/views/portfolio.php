<?php

// default values
if (!isset($portfolio)) {
	$portfolio = array(
				'user_id' => '',
				'nickname' => '',
				'link_url_path' => ''								
			);
}

?>
<?=$this->load->view(branded_view('cp/header'));?>
<h1><?=$form_title;?></h1>
<form class="form validate" id="form_rss" method="post" action="<?=$form_action;?>">
<fieldset>
	<legend>Form Details</legend>
	<ul class="form">
		<li>
			<label class="full" for="title">User ID</label>
		</li>
		
		<li>
			<input type="text" class="required full text" id="user_id" name="user_id" value="<?=$portfolio['user_id'];?>" />
		</li>
		
		<li>
			<label class="full" for="title">Portfolio Name</label>
		</li>
		
		<li>
			<input type="text" class="required full text" id="nickname" name="nickname" value="<?=$portfolio['nickname'];?>" />
		</li>
		
		<li>
			<label for="url_path">URL Path</label>
			<input type="text" class="text mark_empty" id="url_path" rel="e.g, contact-us" name="url_path" style="width:500px" value="<?=$portfolio['link_url_path'];?>" />
		</li>
		
		<li>
			<div class="help">If you leave this blank, it will be auto-generated from the Portfolio Name above.</div>
		</li>
	</ul>
</fieldset>

<div class="submit">
	<input type="submit" class="button" name="form_portfolio" value="Save Portfolio" />
</div>
</form>
<?=$this->load->view(branded_view('cp/footer'));?>