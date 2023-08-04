return {
	{
		"whonore/coqtail",
		config = function()
			-- nmap <leader>c. <leader>cl
			-- nmap <M-down> <leader>cj
			-- nmap <M-up> <leader>ck
			-- nmap <M-right> <leader>cl
			-- nmap <leader>cw :call Coq_do_windows()<CR>
			-- imap <M-down> <c-o><leader>cj
			-- imap <M-up> <c-o><leader>ck
			-- imap <M-right> <c-o><leader>cl

			-- let g:coqtail_noimap=1
		end,
	},
}


-- augroup CoqtailHighlights
--   autocmd!
--   autocmd ColorScheme dracula
--     \  hi def CoqtailChecked ctermbg=0 guibg=#1D3824
--     \| hi def CoqtailSent    ctermbg=53 guibg=#291616
-- augroup END

