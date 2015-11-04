<?=$this->head_assets->javascript('js/data.user_fields.js');?>

<?=$this->load->view(branded_view('cp/header'));?>
<h1>Manage Member Data Fields</h1>
<?=$this->dataset->table_head();?>

<?
if (!empty($this->dataset->data)) {
	foreach ($this->dataset->data as $row) {
	?>
		<tr rel="<?=$row['custom_field_id'];?>">
			<td><input type="checkbox" name="check_<?=$row['id'];?>" value="1" class="action_items" /></td>
			<td><?=$row['custom_field_id'];?></td>
			<td><?=$row['friendly_name'];?></td>
			<td><?=$row['name'];?></td>
			<td><?=$row['type'];?></td>
			<td><? if (module_installed('billing')) { ?>
				<?=form_dropdown('billing_equiv',array(
									'' => 'No',
									'address_1' => 'Address Line 1',
									'address_2' => 'Address Line 2',
									'city' => 'City',
									'state' => 'State/Province',
									'country' => 'Country',
									'postal_code' => 'Postal Code',
									'phone' => 'Phone Number'
								), (isset($row['billing_equiv'])) ? $row['billing_equiv'] : '');?>
				<? } else { ?>
					n/a
				<? } ?>
			</td>
			<td><?=form_checkbox('admin_only', '1', (isset($row['admin_only']) and $row['admin_only'] == TRUE) ? TRUE : FALSE);?></td>
			<td><?=form_checkbox('registration_form', '1', (isset($row['registration_form']) and $row['registration_form'] == FALSE) ? FALSE : TRUE);?></td>
			<td class="options"><a href="<?=site_url('admincp/users/data_edit/' . $row['custom_field_id']);?>">edit</a></td>
		</tr>
	<?
	}
}
?>
<?=$this->dataset->table_close();?>
<?=$this->load->view(branded_view('cp/footer'));?>