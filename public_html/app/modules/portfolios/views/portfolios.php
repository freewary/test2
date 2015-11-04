<?=$this->load->view(branded_view('cp/header'));?>
<h1>Manage Portfolios</h1>
<?=$this->dataset->table_head();?>
<?
if (!empty($this->dataset->data)) {
	foreach ($this->dataset->data as $row) {
	?>
		<tr>
			<td><input type="checkbox" name="check_<?=$row['portfolio_id'];?>" value="1" class="action_items" /></td>
			<td><?=$row['portfolio_id'];?></td>
			<td><?=$row['user_id'];?></td>
			<td><a href="<?=$row['admin_link'];?>"><?=$row['num_trades'];?> Trades</a></td>
			<? /*<td><a href="<?=site_url('admincp/portfolios/edit/' . $row['portfolio_id']);?>"><?=$row['nickname'];?></a></td>*/?>
			<td class="options"> </td>
		</tr>
	<?
	}
}
else {
?>
<tr>
	<td colspan="5">No portfolios have been created.</td>
</tr>
<? } ?>
<?=$this->dataset->table_close();?>
<?=$this->load->view(branded_view('cp/footer'));?>