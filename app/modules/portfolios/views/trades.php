<?=$this->load->view(branded_view('cp/header'));?>
<h1>Manage Trades</h1>
<?=$this->dataset->table_head();?>
<?
if (!empty($this->dataset->data)) {
	foreach ($this->dataset->data as $row) {
	?>
		<tr>
			<td><input type="checkbox" name="check_<?=$row['trade_id'];?>" value="1" class="action_items" /></td>
			<td><?=$row['trade_id'];?></td>
			<td><?=$row['portfolio_id'];?></td>
			<td><?=$row['initial_entry_date'];?></td>
			<td><?=$row['ticker_symbol'];?></td>
			<td><?=$row['quantity'];?></td>
			<td><? if ($row['position'] == 0) { ?>S <? } elseif ($row['position'] == 1) { ?> L <? } ?></td>			
		</tr>
	<?
	}
}
else {
?>
<tr>
	<td colspan="5">There are no submissions to display.</td>
</tr>
<? } ?>
<?=$this->dataset->table_close();?>
<?=$this->load->view(branded_view('cp/footer'));?>