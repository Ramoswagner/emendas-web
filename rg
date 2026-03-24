<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>RG — Gestão de Emendas</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;500;600&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  :root {
    --navy:#07152a; --navy-mid:#0d2240; --navy-light:#163561;
    --navy-card:rgba(13,34,64,0.75);
    --gold:#c9a84c; --gold-light:#e8c96d; --gold-dim:#8a6f2e;
    --cream:#f5f0e8; --text:#e8e4dc; --text-dim:#8fa3b8;
    --border:rgba(201,168,76,0.2);
    --error:#e05a5a; --success:#4caf82; --warning:#e09a3a;
    --sidebar-w:240px;
  }
  html,body{height:100%;font-family:'DM Sans',sans-serif;background:var(--navy);color:var(--text);overflow-x:hidden}

  .bg{position:fixed;inset:0;z-index:0;background:radial-gradient(ellipse 80% 60% at 10% 30%,rgba(22,53,97,.5) 0%,transparent 60%),radial-gradient(ellipse 60% 80% at 90% 80%,rgba(13,34,64,.7) 0%,transparent 55%),#07152a}
  .top-bar{position:fixed;top:0;left:0;right:0;height:3px;z-index:100;background:linear-gradient(90deg,transparent,var(--gold) 40%,var(--gold-light) 60%,transparent)}

  /* ── LAYOUT ── */
  .layout{position:relative;z-index:1;display:flex;min-height:100vh;padding-top:3px}

  /* ── SIDEBAR ── */
  .sidebar{width:var(--sidebar-w);min-height:100vh;background:rgba(7,21,42,.92);border-right:1px solid var(--border);display:flex;flex-direction:column;position:fixed;left:0;top:3px;bottom:0;backdrop-filter:blur(20px);z-index:50}
  .sidebar-header{padding:1.5rem 1.25rem 1rem;border-bottom:1px solid var(--border)}
  .logo-row{display:flex;align-items:center;gap:.65rem;margin-bottom:.4rem}
  .logo-icon{width:32px;height:32px;border-radius:50%;border:1px solid var(--border);background:rgba(201,168,76,.08);display:flex;align-items:center;justify-content:center;flex-shrink:0}
  .logo-text{font-family:'Cormorant Garamond',serif;font-size:1rem;font-weight:500;color:var(--cream);line-height:1.2}
  .logo-sub{font-size:.62rem;letter-spacing:.12em;text-transform:uppercase;color:var(--gold-dim)}
  .nav{flex:1;padding:.75rem 0}
  .nav-label{padding:.4rem 1.25rem .2rem;font-size:.6rem;letter-spacing:.18em;text-transform:uppercase;color:var(--gold-dim);font-weight:500}
  .nav-item{display:flex;align-items:center;gap:.65rem;padding:.6rem 1.25rem;color:var(--text-dim);cursor:pointer;transition:all .2s;font-size:.85rem;border-left:2px solid transparent;text-decoration:none}
  .nav-item:hover{color:var(--text);background:rgba(201,168,76,.05)}
  .nav-item.active{color:var(--gold);border-left-color:var(--gold);background:rgba(201,168,76,.08)}
  .sidebar-footer{padding:.875rem 1.25rem;border-top:1px solid var(--border)}
  .user-info{display:flex;align-items:center;gap:.65rem;margin-bottom:.65rem}
  .user-avatar{width:30px;height:30px;border-radius:50%;background:linear-gradient(135deg,var(--gold-dim),var(--gold));display:flex;align-items:center;justify-content:center;font-size:.72rem;font-weight:500;color:var(--navy);flex-shrink:0}
  .user-name{font-size:.8rem;color:var(--text);font-weight:500}
  .user-role{font-size:.67rem;color:var(--text-dim)}
  .btn-logout{width:100%;padding:.45rem;background:rgba(224,90,90,.08);border:1px solid rgba(224,90,90,.2);border-radius:6px;color:#f08080;font-size:.75rem;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:.4rem;transition:all .2s;font-family:inherit}
  .btn-logout:hover{background:rgba(224,90,90,.15)}

  /* ── MAIN ── */
  .main{margin-left:var(--sidebar-w);flex:1;padding:1.75rem 2rem;animation:fadeIn .5s .1s both}
  @keyframes fadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}

  /* ── TABS ── */
  .tabs-bar{display:flex;gap:0;margin-bottom:1.75rem;border-bottom:1px solid var(--border)}
  .tab-btn{padding:.75rem 1.5rem;font-size:.82rem;font-weight:500;color:var(--text-dim);background:none;border:none;border-bottom:2px solid transparent;cursor:pointer;transition:all .2s;white-space:nowrap;font-family:inherit;display:flex;align-items:center;gap:.5rem}
  .tab-btn:hover{color:var(--text)}
  .tab-btn.active{color:var(--gold);border-bottom-color:var(--gold)}
  .tab-content{display:none}
  .tab-content.active{display:block}

  /* ── CARDS ── */
  .panel{background:var(--navy-card);border:1px solid var(--border);border-radius:14px;backdrop-filter:blur(16px);overflow:hidden;margin-bottom:1.5rem}
  .panel-header{padding:1.1rem 1.5rem;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;gap:1rem;flex-wrap:wrap}
  .panel-title{font-family:'Cormorant Garamond',serif;font-size:1.15rem;font-weight:500;color:var(--cream)}
  .panel-body{padding:1.5rem}

  /* ── FORM GRID ── */
  .form-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:1rem}
  .form-grid.col2{grid-template-columns:repeat(2,1fr)}
  .form-grid.col1{grid-template-columns:1fr}
  .span2{grid-column:span 2}
  .span3{grid-column:span 3}

  .field{display:flex;flex-direction:column;gap:.35rem}
  .field label{font-size:.68rem;letter-spacing:.12em;text-transform:uppercase;color:var(--gold-dim);font-weight:500}
  .field input,.field select,.field textarea{
    padding:.65rem .875rem;background:rgba(7,21,42,.65);
    border:1px solid rgba(201,168,76,.18);border-radius:8px;
    color:var(--text);font-family:'DM Sans',sans-serif;font-size:.875rem;
    outline:none;transition:border-color .2s,box-shadow .2s;width:100%
  }
  .field input:focus,.field select:focus,.field textarea:focus{border-color:var(--gold);box-shadow:0 0 0 3px rgba(201,168,76,.08)}
  .field input::placeholder,.field textarea::placeholder{color:rgba(143,163,184,.4)}
  .field input[readonly]{background:rgba(7,21,42,.4);color:var(--text-dim);cursor:default}
  .field select option{background:#0d2240}
  .field textarea{resize:vertical;min-height:72px}

  /* Total destacado */
  .total-field input{background:rgba(201,168,76,.08)!important;border-color:rgba(201,168,76,.35)!important;color:var(--gold)!important;font-weight:500}

  /* ── BOTÕES ── */
  .btn-row{display:flex;gap:.75rem;margin-top:1.25rem;flex-wrap:wrap}
  .btn-primary{padding:.65rem 1.5rem;background:linear-gradient(135deg,var(--gold-dim),var(--gold));border:none;border-radius:8px;color:var(--navy);font-family:'DM Sans',sans-serif;font-size:.82rem;font-weight:500;letter-spacing:.04em;cursor:pointer;display:flex;align-items:center;gap:.5rem;transition:all .2s;white-space:nowrap}
  .btn-primary:hover{transform:translateY(-1px);box-shadow:0 6px 16px rgba(201,168,76,.25)}
  .btn-primary:disabled{opacity:.6;cursor:not-allowed;transform:none}
  .btn-secondary{padding:.65rem 1.25rem;background:transparent;border:1px solid var(--border);border-radius:8px;color:var(--text-dim);font-family:'DM Sans',sans-serif;font-size:.82rem;cursor:pointer;transition:all .2s}
  .btn-secondary:hover{border-color:rgba(201,168,76,.4);color:var(--text)}
  .btn-danger{padding:.65rem 1.25rem;background:rgba(224,90,90,.1);border:1px solid rgba(224,90,90,.25);border-radius:8px;color:#f08080;font-family:'DM Sans',sans-serif;font-size:.82rem;cursor:pointer;transition:all .2s}
  .btn-danger:hover{background:rgba(224,90,90,.18)}

  /* Spinner */
  .spinner-sm{display:inline-block;width:14px;height:14px;border:2px solid rgba(7,21,42,.3);border-top-color:#07152a;border-radius:50%;animation:spin .7s linear infinite}
  @keyframes spin{to{transform:rotate(360deg)}}

  /* ── TABELA ── */
  .tbl-controls{padding:1rem 1.5rem;border-bottom:1px solid var(--border);display:flex;gap:.75rem;align-items:center;flex-wrap:wrap}
  .search-wrap{position:relative}
  .search-wrap svg{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--text-dim);pointer-events:none}
  input.search{padding:.5rem 1rem .5rem 2.25rem;background:rgba(7,21,42,.6);border:1px solid var(--border);border-radius:8px;color:var(--text);font-family:'DM Sans',sans-serif;font-size:.82rem;outline:none;width:260px;transition:border-color .2s}
  input.search:focus{border-color:var(--gold)}
  input.search::placeholder{color:rgba(143,163,184,.5)}

  .tbl-wrap{overflow-x:auto}
  table{width:100%;border-collapse:collapse;font-size:.82rem}
  thead tr{background:rgba(7,21,42,.5)}
  th{padding:.65rem 1rem;text-align:left;font-size:.65rem;letter-spacing:.1em;text-transform:uppercase;color:var(--gold-dim);font-weight:500;white-space:nowrap;border-bottom:1px solid var(--border)}
  td{padding:.75rem 1rem;color:var(--text);border-bottom:1px solid rgba(201,168,76,.06);vertical-align:middle;max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
  tr:last-child td{border-bottom:none}
  tbody tr{transition:background .15s;cursor:pointer}
  tbody tr:hover{background:rgba(201,168,76,.04)}
  tbody tr.selected{background:rgba(201,168,76,.08)!important}

  .link-cell{color:var(--gold);text-decoration:underline;cursor:pointer}
  .link-cell:hover{color:var(--gold-light)}

  .pill-natureza-c{background:rgba(60,30,107,.2);color:#b08df5;border:1px solid rgba(60,30,107,.3)}
  .pill-natureza-i{background:rgba(30,107,60,.2);color:#6dd6a8;border:1px solid rgba(30,107,60,.3)}
  .pill-natureza-g{background:rgba(123,63,0,.2);color:#f5c56d;border:1px solid rgba(123,63,0,.3)}
  .pill{display:inline-flex;align-items:center;padding:.18rem .6rem;border-radius:20px;font-size:.7rem;font-weight:500;white-space:nowrap}

  /* Ações na tabela */
  .btn-icon{width:28px;height:28px;border-radius:6px;background:transparent;border:1px solid transparent;color:var(--text-dim);cursor:pointer;display:inline-flex;align-items:center;justify-content:center;transition:all .15s;font-family:inherit}
  .btn-icon:hover{background:rgba(201,168,76,.1);color:var(--gold);border-color:var(--border)}
  .btn-icon.danger:hover{background:rgba(224,90,90,.1);color:#f08080;border-color:rgba(224,90,90,.3)}

  /* Empty / loading */
  .empty-state,.loading-state{text-align:center;padding:3rem 1rem;color:var(--text-dim);font-size:.85rem}
  .empty-state svg,.loading-state svg{margin-bottom:.75rem;opacity:.3}

  /* ── SEÇÃO INVESTIMENTOS ── */
  .conta-info-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:.75rem;padding:1rem 1.5rem;background:rgba(7,21,42,.4);border-bottom:1px solid var(--border)}
  .info-item label{font-size:.63rem;letter-spacing:.1em;text-transform:uppercase;color:var(--gold-dim);display:block;margin-bottom:.2rem}
  .info-item span{font-size:.85rem;color:var(--text)}

  /* Toast */
  .toast{position:fixed;bottom:1.75rem;right:1.75rem;z-index:300;padding:.8rem 1.1rem;border-radius:10px;font-size:.83rem;display:flex;align-items:center;gap:.55rem;transform:translateY(20px);opacity:0;transition:all .3s cubic-bezier(.23,1,.32,1);max-width:300px}
  .toast.show{transform:translateY(0);opacity:1}
  .toast.sucesso{background:rgba(76,175,130,.15);border:1px solid rgba(76,175,130,.3);color:#6dd6a8}
  .toast.erro{background:rgba(224,90,90,.15);border:1px solid rgba(224,90,90,.3);color:#f08080}
  .toast.aviso{background:rgba(224,154,58,.15);border:1px solid rgba(224,154,58,.3);color:#f5c56d}

  /* Modal de edição */
  .modal-overlay{position:fixed;inset:0;z-index:200;background:rgba(4,12,24,.88);backdrop-filter:blur(8px);display:flex;align-items:center;justify-content:center;padding:1rem;opacity:0;pointer-events:none;transition:opacity .25s}
  .modal-overlay.open{opacity:1;pointer-events:all}
  .modal{background:#0d2240;border:1px solid var(--border);border-radius:16px;width:100%;max-width:860px;max-height:90vh;box-shadow:0 32px 64px rgba(0,0,0,.6);transform:translateY(20px) scale(.97);transition:transform .3s cubic-bezier(.23,1,.32,1);overflow:hidden;display:flex;flex-direction:column}
  .modal-overlay.open .modal{transform:translateY(0) scale(1)}
  .modal-header{padding:1.25rem 1.5rem;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;flex-shrink:0}
  .modal-title{font-family:'Cormorant Garamond',serif;font-size:1.2rem;font-weight:500;color:var(--cream)}
  .modal-body{padding:1.5rem;overflow-y:auto;flex:1}
  .modal-footer{padding:1rem 1.5rem;border-top:1px solid var(--border);display:flex;justify-content:flex-end;gap:.75rem;flex-shrink:0}
</style>
</head>
<body>
<div class="top-bar"></div>
<div class="bg"></div>

<div class="layout">
  <!-- SIDEBAR -->
  <aside class="sidebar">
    <div class="sidebar-header">
      <div class="logo-row">
        <div class="logo-icon">
          <svg width="16" height="16" viewBox="0 0 32 32" fill="none"><path d="M4 20C4 20 7 14 16 14C25 14 28 18 28 18C28 18 25 24 20 25C15 26 10 24 7 22L4 20Z" stroke="#c9a84c" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><path d="M4 20L2 17C2 17 4 12 9 11" stroke="#c9a84c" stroke-width="1.5" stroke-linecap="round"/><circle cx="22" cy="18" r="1.5" fill="#c9a84c" opacity=".8"/></svg>
        </div>
        <div><div class="logo-text">Gestão de Emendas</div><div class="logo-sub">Hospital da Baleia</div></div>
      </div>
    </div>
    <nav class="nav">
      <div class="nav-label">Módulo RG</div>
      <a class="nav-item active" onclick="ativarTab('cadastro')">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        Cadastrar Emenda
      </a>
      <a class="nav-item" onclick="ativarTab('visualizar')">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
        Visualizar Emendas
      </a>
      <a class="nav-item" onclick="ativarTab('investimentos')">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
        Investimentos
      </a>
      <div class="nav-label" style="margin-top:1rem">Sistema</div>
      <a class="nav-item" href="admin.html">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
        Usuários
      </a>
    </nav>
    <div class="sidebar-footer">
      <div class="user-info">
        <div class="user-avatar" id="sidebarAvatar">?</div>
        <div><div class="user-name" id="sidebarNome">—</div><div class="user-role">Setor RG</div></div>
      </div>
      <button class="btn-logout" onclick="logout()">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
        Sair
      </button>
    </div>
  </aside>

  <!-- MAIN -->
  <main class="main">

    <!-- TABS BAR -->
    <div class="tabs-bar">
      <button class="tab-btn active" id="tab-cadastro" onclick="ativarTab('cadastro')">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        Cadastrar Emenda
      </button>
      <button class="tab-btn" id="tab-visualizar" onclick="ativarTab('visualizar')">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
        Visualizar Emendas
      </button>
      <button class="tab-btn" id="tab-investimentos" onclick="ativarTab('investimentos')">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
        Investimentos — Equipamentos
      </button>
    </div>

    <!-- ═══════════════════════════════════════ -->
    <!-- ABA 1: CADASTRAR EMENDA                -->
    <!-- ═══════════════════════════════════════ -->
    <div class="tab-content active" id="content-cadastro">
      <div class="panel">
        <div class="panel-header">
          <span class="panel-title">Nova Emenda</span>
          <span style="font-size:.75rem;color:var(--text-dim)">Campos marcados com * são obrigatórios</span>
        </div>
        <div class="panel-body">

          <!-- Bloco 1: Identificação -->
          <div style="margin-bottom:1.5rem">
            <div style="font-size:.7rem;letter-spacing:.12em;text-transform:uppercase;color:var(--gold-dim);margin-bottom:.875rem;padding-bottom:.5rem;border-bottom:1px solid var(--border)">Identificação</div>
            <div class="form-grid">
              <div class="field"><label>ANO *</label><input type="text" id="c_ANO" placeholder="Ex: 2024"></div>
              <div class="field"><label>CONTA *</label><input type="text" id="c_CONTA" placeholder="Ex: 12345-6"></div>
              <div class="field"><label>Nº ADITIVO</label><input type="text" id="c_N_ADITIVO" placeholder="Ex: 1º Aditivo"></div>
              <div class="field span2"><label>TERMO DE COOPERAÇÃO</label><input type="text" id="c_TERMO_COOPERACAO" placeholder="Ex: TC nº 001/2024"></div>
              <div class="field"><label>Nº DA PROPOSTA</label><input type="text" id="c_N_PROPOSTA" placeholder="Ex: 202400001"></div>
              <div class="field"><label>ESFERA</label>
                <select id="c_ESFERA"><option value="">Selecione...</option><option>MUNICIPAL</option><option>ESTADUAL</option><option>FEDERAL</option></select>
              </div>
              <div class="field"><label>ORIGEM</label>
                <select id="c_ORIGEM"><option value="">Selecione...</option><option>EMENDA</option><option>PROGRAMA</option></select>
              </div>
              <div class="field"><label>TIPO DE EMENDA</label>
                <select id="c_TIPO_EMENDA"><option value="">Selecione...</option><option>INDIVIDUAL</option><option>BANCADA</option><option>COMISSÃO</option><option>DISCRICIONÁRIO</option><option>EXTRA</option></select>
              </div>
              <div class="field"><label>NATUREZA DA DESPESA</label>
                <select id="c_NATUREZA_DESPESA"><option value="">Selecione...</option><option>CUSTEIO</option><option>INVESTIMENTO</option><option>GERAL</option></select>
              </div>
              <div class="field span2"><label>INDICAÇÃO PARLAMENTAR</label><input type="text" id="c_INDICACAO_PARLAMENTAR" placeholder="Nome do parlamentar"></div>
              <div class="field span3"><label>ÁREA DEMANDANTE</label><input type="text" id="c_AREA_DEMANDANTE" placeholder="Ex: Unidade de Saúde ABC"></div>
            </div>
          </div>

          <!-- Bloco 2: Datas e Vigência -->
          <div style="margin-bottom:1.5rem">
            <div style="font-size:.7rem;letter-spacing:.12em;text-transform:uppercase;color:var(--gold-dim);margin-bottom:.875rem;padding-bottom:.5rem;border-bottom:1px solid var(--border)">Datas e Vigência</div>
            <div class="form-grid">
              <div class="field"><label>DATA PUBLICAÇÃO</label><input type="date" id="c_DATA_PUBLICACAO"></div>
              <div class="field"><label>DATA ASSINATURA DO TERMO</label><input type="date" id="c_DATA_ASSINATURA_TERMO"></div>
              <div class="field"><label>INÍCIO DA VIGÊNCIA</label><input type="date" id="c_INICIO_VIGENCIA"></div>
              <div class="field"><label>TÉRMINO DA VIGÊNCIA</label><input type="date" id="c_TERMINO_VIGENCIA"></div>
              <div class="field"><label>REGRA DE PRESTAÇÃO DE CONTAS</label>
                <select id="c_REGRA_PRESTACAO_CONTAS">
                  <option value="">Selecione...</option>
                  <option>Semanal</option><option>Quinzenal</option><option>Mensal</option>
                  <option>Bimestral</option><option>Trimestral</option><option>Semestral</option>
                  <option>Anual</option><option>Ao final do ano</option><option>Ao final da vigência</option>
                </select>
              </div>
            </div>
          </div>

          <!-- Bloco 3: Valores -->
          <div style="margin-bottom:1.5rem">
            <div style="font-size:.7rem;letter-spacing:.12em;text-transform:uppercase;color:var(--gold-dim);margin-bottom:.875rem;padding-bottom:.5rem;border-bottom:1px solid var(--border)">Valores</div>
            <div class="form-grid">
              <div class="field"><label>VALOR DA PROPOSTA</label><input type="number" id="c_VALOR_DA_PROPOSTA" placeholder="0.00" step="0.01"></div>
              <div class="field"><label>CONTRAPARTIDA</label><input type="number" id="c_CONTRAPARTIDA" placeholder="0.00" step="0.01"></div>
              <div class="field"><label>1ª PARCELA</label><input type="number" id="c_PARCELA_1" placeholder="0.00" step="0.01" oninput="calcularTotal()"></div>
              <div class="field"><label>DATA 1ª PARCELA</label><input type="date" id="c_DATA_PARCELA_1"></div>
              <div class="field"><label>2ª PARCELA</label><input type="number" id="c_PARCELA_2" placeholder="0.00" step="0.01" oninput="calcularTotal()"></div>
              <div class="field"><label>DATA 2ª PARCELA</label><input type="date" id="c_DATA_PARCELA_2"></div>
              <div class="field total-field"><label>TOTAL CREDITADO</label><input type="text" id="c_TOTAL_CREDITADO" readonly placeholder="0.00"></div>
              <div class="field"><label>VALOR DESTINADO A FOLHA</label><input type="number" id="c_VALOR_DESTINADO_FOLHA" placeholder="0.00" step="0.01"></div>
              <div class="field"><label>VALOR DESTINADO A INVESTIMENTOS</label><input type="number" id="c_VALOR_DESTINADO_INVESTIMENTOS" placeholder="0.00" step="0.01"></div>
              <div class="field"><label>VALOR DESTINADO A CUSTEIO</label><input type="number" id="c_VALOR_DESTINADO_CUSTEIO" placeholder="0.00" step="0.01"></div>
            </div>
          </div>

          <!-- Bloco 4: Links e Documentação -->
          <div style="margin-bottom:1.5rem">
            <div style="font-size:.7rem;letter-spacing:.12em;text-transform:uppercase;color:var(--gold-dim);margin-bottom:.875rem;padding-bottom:.5rem;border-bottom:1px solid var(--border)">Links e Documentação</div>
            <div class="form-grid col2">
              <div class="field"><label>LINK DO TERMO</label><input type="url" id="c_LINK_DO_TERMO" placeholder="https://..."></div>
              <div class="field"><label>LINK CI DO TERMO</label><input type="url" id="c_LINK_CI_DO_TERMO" placeholder="https://..."></div>
              <div class="field span2"><label>ORIENTAÇÃO PARA UTILIZAÇÃO DO RECURSO</label><textarea id="c_ORIENTACAO_UTILIZACAO" placeholder="Descreva as orientações..."></textarea></div>
              <div class="field"><label>PORTARIA DE HABILITAÇÃO / RESOLUÇÃO</label><input type="text" id="c_PORTARIA_HABILITACAO" placeholder="Ex: Portaria nº 123/2024"></div>
              <div class="field"><label>LEGISLAÇÃO</label><input type="text" id="c_LEGISLACAO" placeholder="Ex: Lei nº 12.345/2024"></div>
              <div class="field span2"><label>INDICADORES / METAS</label><textarea id="c_INDICADORES_METAS" placeholder="Descreva os indicadores e metas..."></textarea></div>
            </div>
          </div>

          <div id="alertCadastro" style="display:none;padding:.65rem .9rem;border-radius:8px;font-size:.82rem;margin-bottom:1rem;background:rgba(224,90,90,.12);border:1px solid rgba(224,90,90,.3);color:#f08080"></div>

          <div class="btn-row">
            <button class="btn-primary" id="btnSalvarEmenda" onclick="salvarEmenda()">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
              <span id="btnSalvarEmendaTxt">Salvar Emenda</span>
              <span class="spinner-sm" id="btnSalvarEmendaSpin" style="display:none"></span>
            </button>
            <button class="btn-secondary" onclick="limparFormCadastro()">Limpar formulário</button>
          </div>
        </div>
      </div>
    </div>

    <!-- ═══════════════════════════════════════ -->
    <!-- ABA 2: VISUALIZAR EMENDAS              -->
    <!-- ═══════════════════════════════════════ -->
    <div class="tab-content" id="content-visualizar">
      <div class="panel">
        <div class="tbl-controls">
          <div class="search-wrap">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input class="search" type="text" id="searchEmendas" placeholder="Buscar por conta, termo, parlamentar..." oninput="filtrarEmendas()">
          </div>
          <select id="filtroNatureza" onchange="filtrarEmendas()" style="padding:.5rem .875rem;background:rgba(7,21,42,.6);border:1px solid var(--border);border-radius:8px;color:var(--text);font-family:'DM Sans',sans-serif;font-size:.82rem;outline:none">
            <option value="">Todas as naturezas</option>
            <option>CUSTEIO</option><option>INVESTIMENTO</option><option>GERAL</option>
          </select>
          <button class="btn-primary" onclick="carregarEmendas()" style="margin-left:auto">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 11-2.12-9.36L23 10"/></svg>
            Atualizar
          </button>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead><tr>
              <th>ANO</th><th>CONTA</th><th>TERMO DE COOPERAÇÃO</th>
              <th>NATUREZA</th><th>ESFERA</th><th>INDICAÇÃO PARLAMENTAR</th>
              <th>TOTAL CREDITADO</th><th>VIGÊNCIA</th><th>LINKS</th><th>AÇÕES</th>
            </tr></thead>
            <tbody id="tbodyEmendas">
              <tr><td colspan="10" class="loading-state">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/></svg>
                <p>Clique em "Atualizar" para carregar as emendas</p>
              </td></tr>
            </tbody>
          </table>
        </div>
        <div id="tblFooter" style="padding:.75rem 1.5rem;border-top:1px solid var(--border);font-size:.75rem;color:var(--text-dim);display:none">
          <span id="tblCount"></span>
        </div>
      </div>
    </div>

    <!-- ═══════════════════════════════════════ -->
    <!-- ABA 3: INVESTIMENTOS / EQUIPAMENTOS    -->
    <!-- ═══════════════════════════════════════ -->
    <div class="tab-content" id="content-investimentos">
      <!-- Seleção de conta -->
      <div class="panel" style="margin-bottom:1rem">
        <div class="panel-header">
          <span class="panel-title">Selecionar Conta de Investimento</span>
        </div>
        <div class="panel-body" style="padding:1rem 1.5rem">
          <div style="display:flex;gap:1rem;align-items:flex-end;flex-wrap:wrap">
            <div class="field" style="flex:1;min-width:200px">
              <label>CONTA COM INVESTIMENTO</label>
              <select id="contaInvestimento" onchange="carregarDadosConta()">
                <option value="">Selecione uma conta...</option>
              </select>
            </div>
            <button class="btn-secondary" onclick="carregarContasInvestimento()">
              <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 11-2.12-9.36L23 10"/></svg>
              Atualizar lista
            </button>
          </div>
        </div>
        <!-- Info da conta selecionada -->
        <div class="conta-info-grid" id="contaInfoGrid" style="display:none">
          <div class="info-item"><label>Ano</label><span id="ci_ano">—</span></div>
          <div class="info-item"><label>Esfera</label><span id="ci_esfera">—</span></div>
          <div class="info-item"><label>Indicação Parlamentar</label><span id="ci_parlamentar">—</span></div>
          <div class="info-item"><label>Termo de Cooperação</label><span id="ci_termo">—</span></div>
          <div class="info-item"><label>Início da Vigência</label><span id="ci_inicio">—</span></div>
          <div class="info-item"><label>Término da Vigência</label><span id="ci_termino">—</span></div>
          <div class="info-item"><label>Valor da Proposta</label><span id="ci_valor">—</span></div>
          <div class="info-item"><label>Natureza da Despesa</label><span id="ci_natureza">—</span></div>
        </div>
      </div>

      <!-- Cadastro de equipamento -->
      <div class="panel" style="margin-bottom:1rem">
        <div class="panel-header"><span class="panel-title">Cadastrar Equipamento</span></div>
        <div class="panel-body">
          <div class="form-grid">
            <div class="field span2"><label>DESCRIÇÃO DO EQUIPAMENTO *</label><input type="text" id="e_descricao" placeholder="Ex: Monitor multiparamétrico..."></div>
            <div class="field"><label>SETOR DESTINADO *</label><input type="text" id="e_setor" placeholder="Ex: UTI Adulto"></div>
            <div class="field"><label>QUANTIDADE *</label><input type="number" id="e_qtd" value="1" min="1" oninput="calcularTotalEquip()"></div>
            <div class="field"><label>VALOR UNITÁRIO *</label><input type="number" id="e_unit" placeholder="0.00" step="0.01" oninput="calcularTotalEquip()"></div>
            <div class="field total-field"><label>VALOR TOTAL</label><input type="text" id="e_total" readonly placeholder="0.00"></div>
          </div>
          <div id="alertEquip" style="display:none;padding:.65rem .9rem;border-radius:8px;font-size:.82rem;margin-top:.75rem;background:rgba(224,90,90,.12);border:1px solid rgba(224,90,90,.3);color:#f08080"></div>
          <div class="btn-row">
            <button class="btn-primary" id="btnSalvarEquip" onclick="salvarEquipamento()">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/></svg>
              <span id="btnSalvarEquipTxt">Salvar Equipamento</span>
              <span class="spinner-sm" id="btnSalvarEquipSpin" style="display:none"></span>
            </button>
          </div>
        </div>
      </div>

      <!-- Histórico de equipamentos -->
      <div class="panel">
        <div class="panel-header">
          <span class="panel-title">Histórico de Equipamentos</span>
          <button class="btn-secondary" onclick="carregarEquipamentos()" style="font-size:.78rem;padding:.4rem .9rem">Atualizar</button>
        </div>
        <div class="tbl-wrap">
          <table>
            <thead><tr>
              <th>CONTA</th><th>DESCRIÇÃO</th><th>QTDE</th><th>VALOR UNIT.</th>
              <th>VALOR TOTAL</th><th>SETOR DESTINADO</th><th>CADASTRADO EM</th><th>AÇÃO</th>
            </tr></thead>
            <tbody id="tbodyEquip">
              <tr><td colspan="8" class="loading-state"><p>Selecione uma conta para ver os equipamentos</p></td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

  </main>
</div>

<!-- MODAL EDITAR EMENDA -->
<div class="modal-overlay" id="modalEditar">
  <div class="modal">
    <div class="modal-header">
      <span class="modal-title">Editar Emenda</span>
      <button class="btn-icon" onclick="fecharModalEditar()">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
      </button>
    </div>
    <div class="modal-body" id="modalEditarBody"><!-- preenchido dinâmicamente --></div>
    <div class="modal-footer">
      <button class="btn-secondary" onclick="fecharModalEditar()">Cancelar</button>
      <button class="btn-primary" id="btnConfirmarEdicao" onclick="confirmarEdicao()">
        <span id="btnEdicaoTxt">Salvar Alterações</span>
        <span class="spinner-sm" id="btnEdicaoSpin" style="display:none"></span>
      </button>
    </div>
  </div>
</div>

<div class="toast" id="toast"></div>

<script>
// ══════════════════════════════════════════════════
const API_URL = 'COLE_AQUI_A_URL_DO_APPS_SCRIPT';
// ══════════════════════════════════════════════════

let TOKEN = null, SESSAO = null;
let EMENDAS = [], EMENDAS_FILTRADAS = [];
let EMENDA_EDITANDO_ID = null;
let CONTA_SELECIONADA = null;

// ── INIT ──
document.addEventListener('DOMContentLoaded', () => {
  TOKEN = localStorage.getItem('emendas_token');
  const raw = localStorage.getItem('emendas_usuario');
  if (!TOKEN || !raw) { window.location.href = 'index.html'; return; }
  SESSAO = JSON.parse(raw);
  if (!['RG','NucleoProj'].includes(SESSAO.setor)) {
    showToast('Acesso negado para este setor.','erro');
    setTimeout(() => window.location.href = 'index.html', 2000); return;
  }
  document.getElementById('sidebarNome').textContent  = SESSAO.nome;
  document.getElementById('sidebarAvatar').textContent = SESSAO.nome.charAt(0).toUpperCase();
  carregarContasInvestimento();
});

// ── API ──
async function api(acao, payload = {}) {
  const res = await fetch(API_URL, {
    method:'POST', headers:{'Content-Type':'text/plain'},
    body: JSON.stringify({ acao, token: TOKEN, payload })
  });
  if (!res.ok) throw new Error('Erro de rede: ' + res.status);
  const data = await res.json();
  if (data.relogin) { localStorage.clear(); window.location.href = 'index.html'; }
  return data;
}

// ── TABS ──
function ativarTab(tab) {
  ['cadastro','visualizar','investimentos'].forEach(t => {
    document.getElementById('content-' + t).classList.toggle('active', t === tab);
    document.getElementById('tab-' + t).classList.toggle('active', t === tab);
    document.querySelectorAll('.nav-item').forEach((el,i) => {
      if (i < 3) el.classList.toggle('active', i === ['cadastro','visualizar','investimentos'].indexOf(tab));
    });
  });
  if (tab === 'visualizar' && EMENDAS.length === 0) carregarEmendas();
}

// ── TOTAL AUTOMÁTICO ──
function calcularTotal() {
  const p1 = parseFloat(document.getElementById('c_PARCELA_1').value) || 0;
  const p2 = parseFloat(document.getElementById('c_PARCELA_2').value) || 0;
  document.getElementById('c_TOTAL_CREDITADO').value = (p1 + p2).toFixed(2);
}
function calcularTotalEquip() {
  const qtd  = parseFloat(document.getElementById('e_qtd').value)  || 0;
  const unit = parseFloat(document.getElementById('e_unit').value) || 0;
  document.getElementById('e_total').value = (qtd * unit).toFixed(2);
}

// ── SALVAR EMENDA ──
async function salvarEmenda() {
  const conta = document.getElementById('c_CONTA').value.trim();
  const ano   = document.getElementById('c_ANO').value.trim();
  if (!conta) { mostrarAlertCadastro('Campo CONTA é obrigatório.'); return; }
  if (!ano)   { mostrarAlertCadastro('Campo ANO é obrigatório.');   return; }

  setBtnLoading('btnSalvarEmenda','btnSalvarEmendaTxt','btnSalvarEmendaSpin', true);

  const campos = [
    'ANO','CONTA','N_ADITIVO','TERMO_COOPERACAO','LINK_DO_TERMO','LINK_CI_DO_TERMO',
    'VALOR_DA_PROPOSTA','INICIO_VIGENCIA','TERMINO_VIGENCIA','ESFERA','ORIGEM','TIPO_EMENDA',
    'NATUREZA_DESPESA','INDICACAO_PARLAMENTAR','N_PROPOSTA','DATA_PUBLICACAO',
    'DATA_ASSINATURA_TERMO','INDICADORES_METAS','AREA_DEMANDANTE','CONTRAPARTIDA',
    'REGRA_PRESTACAO_CONTAS','PARCELA_1','DATA_PARCELA_1','PARCELA_2','DATA_PARCELA_2',
    'VALOR_DESTINADO_FOLHA','VALOR_DESTINADO_INVESTIMENTOS','VALOR_DESTINADO_CUSTEIO',
    'ORIENTACAO_UTILIZACAO','PORTARIA_HABILITACAO','LEGISLACAO'
  ];

  const payload = {};
  campos.forEach(c => {
    const el = document.getElementById('c_' + c);
    if (el) payload[c.replace('N_ADITIVO','Nº_ADITIVO').replace('N_PROPOSTA','Nº_PROPOSTA')] = el.value;
  });

  try {
    const res = await api('emendas.salvar', payload);
    if (!res.ok) { mostrarAlertCadastro(res.erro); return; }
    showToast(res.msg, 'sucesso');
    limparFormCadastro();
    EMENDAS = []; // força reload na próxima visita à aba
    carregarContasInvestimento();
  } catch(e) {
    mostrarAlertCadastro('Erro de conexão. Tente novamente.');
  } finally {
    setBtnLoading('btnSalvarEmenda','btnSalvarEmendaTxt','btnSalvarEmendaSpin', false);
  }
}

function limparFormCadastro() {
  document.querySelectorAll('[id^="c_"]').forEach(el => {
    if (el.tagName === 'SELECT') el.value = '';
    else el.value = '';
  });
  document.getElementById('alertCadastro').style.display = 'none';
}

function mostrarAlertCadastro(msg) {
  const el = document.getElementById('alertCadastro');
  el.textContent = msg; el.style.display = 'block';
}

// ── CARREGAR EMENDAS ──
async function carregarEmendas() {
  document.getElementById('tbodyEmendas').innerHTML =
    '<tr><td colspan="10" style="text-align:center;padding:2rem;color:var(--text-dim)"><span class="spinner-sm" style="border-color:rgba(201,168,76,.2);border-top-color:var(--gold)"></span> Carregando...</td></tr>';
  try {
    const res = await api('emendas.listar');
    if (!res.ok) { showToast(res.erro,'erro'); return; }
    EMENDAS = res.dados || [];
    EMENDAS_FILTRADAS = [...EMENDAS];
    renderEmendas(EMENDAS_FILTRADAS);
  } catch(e) {
    showToast('Erro ao carregar emendas.','erro');
  }
}

function filtrarEmendas() {
  const q  = document.getElementById('searchEmendas').value.toLowerCase();
  const nat= document.getElementById('filtroNatureza').value;
  EMENDAS_FILTRADAS = EMENDAS.filter(e => {
    const texto = [e.CONTA,e.TERMO_COOPERACAO,e.INDICACAO_PARLAMENTAR,e.ANO,e.ESFERA]
      .map(v => String(v||'').toLowerCase()).join(' ');
    const matchQ   = !q   || texto.includes(q);
    const matchNat = !nat || String(e.NATUREZA_DESPESA||'') === nat;
    return matchQ && matchNat;
  });
  renderEmendas(EMENDAS_FILTRADAS);
}

function renderEmendas(lista) {
  const tbody = document.getElementById('tbodyEmendas');
  if (!lista.length) {
    tbody.innerHTML = '<tr><td colspan="10" class="empty-state"><p>Nenhuma emenda encontrada</p></td></tr>';
    document.getElementById('tblFooter').style.display = 'none';
    return;
  }

  const pillNat = { 'CUSTEIO':'pill-natureza-c','INVESTIMENTO':'pill-natureza-i','GERAL':'pill-natureza-g' };

  tbody.innerHTML = lista.map(e => {
    const nat = String(e.NATUREZA_DESPESA||'');
    const pill= pillNat[nat] || '';
    const total = parseFloat(e.TOTAL_CREDITADO||0).toLocaleString('pt-BR',{style:'currency',currency:'BRL'});
    const vigencia = e.TERMINO_VIGENCIA ? new Date(e.TERMINO_VIGENCIA).toLocaleDateString('pt-BR') : '—';

    const linkTermo = e.LINK_DO_TERMO
      ? `<a href="${e.LINK_DO_TERMO}" target="_blank" class="link-cell" title="Abrir link do termo">Termo</a>`
      : '<span style="color:var(--text-dim)">—</span>';
    const linkCI = e.LINK_CI_DO_TERMO
      ? `<a href="${e.LINK_CI_DO_TERMO}" target="_blank" class="link-cell" title="Abrir CI do termo">CI</a>`
      : '';

    return `<tr onclick="selecionarLinha(this)" data-id="${e.id}">
      <td>${String(e.ANO||'—')}</td>
      <td><strong style="color:var(--cream)">${String(e.CONTA||'—')}</strong></td>
      <td title="${String(e.TERMO_COOPERACAO||'')}"><span style="max-width:160px;display:block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${String(e.TERMO_COOPERACAO||'—')}</span></td>
      <td>${nat ? `<span class="pill ${pill}">${nat}</span>` : '—'}</td>
      <td>${String(e.ESFERA||'—')}</td>
      <td title="${String(e.INDICACAO_PARLAMENTAR||'')}"><span style="max-width:140px;display:block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${String(e.INDICACAO_PARLAMENTAR||'—')}</span></td>
      <td style="color:var(--gold);font-weight:500">${total}</td>
      <td style="color:var(--text-dim)">${vigencia}</td>
      <td style="white-space:nowrap">${linkTermo} ${linkCI}</td>
      <td onclick="event.stopPropagation()">
        <div style="display:flex;gap:.25rem">
          <button class="btn-icon" title="Editar" onclick="abrirModalEditar('${e.id}')">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
          </button>
          <button class="btn-icon danger" title="Excluir" onclick="excluirEmenda('${e.id}','${String(e.CONTA||'')}')">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/></svg>
          </button>
        </div>
      </td>
    </tr>`;
  }).join('');

  document.getElementById('tblFooter').style.display = 'block';
  document.getElementById('tblCount').textContent = lista.length + ' emenda(s) encontrada(s)';
}

function selecionarLinha(tr) {
  document.querySelectorAll('#tbodyEmendas tr').forEach(r => r.classList.remove('selected'));
  tr.classList.add('selected');
}

// ── EDITAR EMENDA ──
function abrirModalEditar(id) {
  const e = EMENDAS.find(x => x.id === id);
  if (!e) return;
  EMENDA_EDITANDO_ID = id;

  const campos = [
    {k:'ANO',l:'ANO',t:'text'},{k:'CONTA',l:'CONTA',t:'text',r:true},
    {k:'Nº_ADITIVO',l:'Nº ADITIVO',t:'text'},{k:'TERMO_COOPERACAO',l:'TERMO DE COOPERAÇÃO',t:'text'},
    {k:'ESFERA',l:'ESFERA',t:'select',opts:['MUNICIPAL','ESTADUAL','FEDERAL']},
    {k:'ORIGEM',l:'ORIGEM',t:'select',opts:['EMENDA','PROGRAMA']},
    {k:'TIPO_EMENDA',l:'TIPO DE EMENDA',t:'select',opts:['INDIVIDUAL','BANCADA','COMISSÃO','DISCRICIONÁRIO','EXTRA']},
    {k:'NATUREZA_DESPESA',l:'NATUREZA DA DESPESA',t:'select',opts:['CUSTEIO','INVESTIMENTO','GERAL']},
    {k:'INDICACAO_PARLAMENTAR',l:'INDICAÇÃO PARLAMENTAR',t:'text'},
    {k:'AREA_DEMANDANTE',l:'ÁREA DEMANDANTE',t:'text'},
    {k:'INICIO_VIGENCIA',l:'INÍCIO DA VIGÊNCIA',t:'date'},
    {k:'TERMINO_VIGENCIA',l:'TÉRMINO DA VIGÊNCIA',t:'date'},
    {k:'REGRA_PRESTACAO_CONTAS',l:'REGRA DE PRESTAÇÃO DE CONTAS',t:'select',opts:['Semanal','Quinzenal','Mensal','Bimestral','Trimestral','Semestral','Anual','Ao final do ano','Ao final da vigência']},
    {k:'VALOR_DA_PROPOSTA',l:'VALOR DA PROPOSTA',t:'number'},
    {k:'CONTRAPARTIDA',l:'CONTRAPARTIDA',t:'number'},
    {k:'PARCELA_1',l:'1ª PARCELA',t:'number'},{k:'DATA_PARCELA_1',l:'DATA 1ª PARCELA',t:'date'},
    {k:'PARCELA_2',l:'2ª PARCELA',t:'number'},{k:'DATA_PARCELA_2',l:'DATA 2ª PARCELA',t:'date'},
    {k:'VALOR_DESTINADO_FOLHA',l:'VALOR DESTINADO A FOLHA',t:'number'},
    {k:'VALOR_DESTINADO_INVESTIMENTOS',l:'VALOR DESTINADO A INVESTIMENTOS',t:'number'},
    {k:'VALOR_DESTINADO_CUSTEIO',l:'VALOR DESTINADO A CUSTEIO',t:'number'},
    {k:'LINK_DO_TERMO',l:'LINK DO TERMO',t:'url'},{k:'LINK_CI_DO_TERMO',l:'LINK CI DO TERMO',t:'url'},
    {k:'ORIENTACAO_UTILIZACAO',l:'ORIENTAÇÃO PARA UTILIZAÇÃO',t:'textarea'},
    {k:'PORTARIA_HABILITACAO',l:'PORTARIA DE HABILITAÇÃO',t:'text'},
    {k:'LEGISLACAO',l:'LEGISLAÇÃO',t:'text'},
    {k:'INDICADORES_METAS',l:'INDICADORES / METAS',t:'textarea'},
  ];

  const html = '<div class="form-grid col2">' + campos.map(c => {
    const val = String(e[c.k]||'');
    const readonly = c.r ? 'readonly' : '';
    let input = '';
    if (c.t === 'select') {
      input = `<select id="ed_${c.k}" class="field-input" ${readonly}>
        <option value="">—</option>
        ${c.opts.map(o=>`<option ${val===o?'selected':''}>${o}</option>`).join('')}
      </select>`;
    } else if (c.t === 'textarea') {
      input = `<textarea id="ed_${c.k}" style="padding:.65rem .875rem;background:rgba(7,21,42,.65);border:1px solid rgba(201,168,76,.18);border-radius:8px;color:var(--text);font-family:DM Sans,sans-serif;font-size:.875rem;outline:none;width:100%;min-height:60px;resize:vertical">${val}</textarea>`;
    } else {
      input = `<input type="${c.t}" id="ed_${c.k}" value="${val}" ${readonly} style="padding:.65rem .875rem;background:rgba(7,21,42,.65);border:1px solid rgba(201,168,76,.18);border-radius:8px;color:var(--text);font-family:DM Sans,sans-serif;font-size:.875rem;outline:none;width:100%;transition:border-color .2s">`;
    }
    const span = (c.k === 'ORIENTACAO_UTILIZACAO' || c.k === 'INDICADORES_METAS') ? 'span2' : '';
    return `<div class="field ${span}"><label style="font-size:.65rem;letter-spacing:.1em;text-transform:uppercase;color:var(--gold-dim);margin-bottom:.3rem;display:block;font-weight:500">${c.l}</label>${input}</div>`;
  }).join('') + '</div>';

  document.getElementById('modalEditarBody').innerHTML = html;
  document.getElementById('modalEditar').classList.add('open');
}

async function confirmarEdicao() {
  if (!EMENDA_EDITANDO_ID) return;
  setBtnLoading('btnConfirmarEdicao','btnEdicaoTxt','btnEdicaoSpin', true);

  const campos = ['ANO','CONTA','Nº_ADITIVO','TERMO_COOPERACAO','ESFERA','ORIGEM','TIPO_EMENDA',
    'NATUREZA_DESPESA','INDICACAO_PARLAMENTAR','AREA_DEMANDANTE','INICIO_VIGENCIA','TERMINO_VIGENCIA',
    'REGRA_PRESTACAO_CONTAS','VALOR_DA_PROPOSTA','CONTRAPARTIDA','PARCELA_1','DATA_PARCELA_1',
    'PARCELA_2','DATA_PARCELA_2','VALOR_DESTINADO_FOLHA','VALOR_DESTINADO_INVESTIMENTOS',
    'VALOR_DESTINADO_CUSTEIO','LINK_DO_TERMO','LINK_CI_DO_TERMO','ORIENTACAO_UTILIZACAO',
    'PORTARIA_HABILITACAO','LEGISLACAO','INDICADORES_METAS'];

  const payload = { id: EMENDA_EDITANDO_ID };
  campos.forEach(c => {
    const el = document.getElementById('ed_' + c);
    if (el) payload[c] = el.value;
  });

  try {
    const res = await api('emendas.editar', payload);
    if (!res.ok) { showToast(res.erro,'erro'); return; }
    showToast(res.msg,'sucesso');
    fecharModalEditar();
    carregarEmendas();
  } catch(e) {
    showToast('Erro de conexão.','erro');
  } finally {
    setBtnLoading('btnConfirmarEdicao','btnEdicaoTxt','btnEdicaoSpin', false);
  }
}

function fecharModalEditar() {
  document.getElementById('modalEditar').classList.remove('open');
  EMENDA_EDITANDO_ID = null;
}

async function excluirEmenda(id, conta) {
  if (!confirm('Excluir a emenda da conta "' + conta + '"?\n\nEsta ação não pode ser desfeita.')) return;
  try {
    const res = await api('emendas.excluir', { id });
    if (!res.ok) { showToast(res.erro,'erro'); return; }
    showToast(res.msg,'sucesso');
    carregarEmendas();
  } catch(e) {
    showToast('Erro ao excluir.','erro');
  }
}

// ── INVESTIMENTOS ──
async function carregarContasInvestimento() {
  try {
    const res = await api('emendas.contas', { natureza: 'INVESTIMENTO' });
    if (!res.ok) return;
    const sel = document.getElementById('contaInvestimento');
    sel.innerHTML = '<option value="">Selecione uma conta...</option>' +
      (res.dados||[]).map(c => `<option value="${c.conta}">${c.conta} — ${c.termo||''}</option>`).join('');
  } catch(e) { /* silencioso */ }
}

function carregarDadosConta() {
  const conta = document.getElementById('contaInvestimento').value;
  if (!conta) { document.getElementById('contaInfoGrid').style.display = 'none'; return; }

  const emenda = EMENDAS.find(e => e.CONTA === conta);
  if (!emenda) {
    // Busca assíncrona se emendas não foram carregadas ainda
    api('emendas.contas').then(res => {
      const c = (res.dados||[]).find(x => x.conta === conta);
      if (c) preencherInfoConta(c);
    });
    return;
  }

  preencherInfoConta({
    conta: emenda.CONTA,
    ano: emenda.ANO,
    esfera: emenda.ESFERA,
    indicacao_parlamentar: emenda.INDICACAO_PARLAMENTAR,
    termo: emenda.TERMO_COOPERACAO,
    inicio: emenda.INICIO_VIGENCIA,
    termino: emenda.TERMINO_VIGENCIA,
    valor: emenda.VALOR_DA_PROPOSTA,
    natureza: emenda.NATUREZA_DESPESA
  });

  CONTA_SELECIONADA = conta;
  carregarEquipamentos();
}

function preencherInfoConta(c) {
  document.getElementById('ci_ano').textContent       = c.ano || '—';
  document.getElementById('ci_esfera').textContent    = c.esfera || '—';
  document.getElementById('ci_parlamentar').textContent = c.indicacao_parlamentar || c.parlamentar || '—';
  document.getElementById('ci_termo').textContent     = c.termo || '—';
  document.getElementById('ci_inicio').textContent    = c.inicio || c.inicio_vigencia || '—';
  document.getElementById('ci_termino').textContent   = c.termino || c.termino_vigencia || '—';
  document.getElementById('ci_valor').textContent     = c.valor
    ? parseFloat(c.valor).toLocaleString('pt-BR',{style:'currency',currency:'BRL'})
    : '—';
  document.getElementById('ci_natureza').textContent  = c.natureza || '—';
  document.getElementById('contaInfoGrid').style.display = 'grid';
  CONTA_SELECIONADA = c.conta;
  carregarEquipamentos();
}

async function salvarEquipamento() {
  const conta = document.getElementById('contaInvestimento').value;
  if (!conta)  { document.getElementById('alertEquip').textContent='Selecione uma conta primeiro.'; document.getElementById('alertEquip').style.display='block'; return; }

  const desc  = document.getElementById('e_descricao').value.trim();
  const setor = document.getElementById('e_setor').value.trim();
  if (!desc)  { document.getElementById('alertEquip').textContent='Descrição é obrigatória.'; document.getElementById('alertEquip').style.display='block'; return; }
  if (!setor) { document.getElementById('alertEquip').textContent='Setor destinado é obrigatório.'; document.getElementById('alertEquip').style.display='block'; return; }

  document.getElementById('alertEquip').style.display = 'none';
  setBtnLoading('btnSalvarEquip','btnSalvarEquipTxt','btnSalvarEquipSpin', true);

  // Buscar dados da emenda para preencher os campos completos
  const emenda = EMENDAS.find(e => e.CONTA === conta) || {};

  const payload = {
    conta,
    descricao_equipamento: desc,
    quantidade:    parseFloat(document.getElementById('e_qtd').value)  || 1,
    valor_unitario:parseFloat(document.getElementById('e_unit').value) || 0,
    valor_total:   parseFloat(document.getElementById('e_total').value)|| 0,
    setor_destinado: setor,
    ano:                emenda.ANO || '',
    esfera:             emenda.ESFERA || '',
    indicacao_parlamentar: emenda.INDICACAO_PARLAMENTAR || '',
    n_aditivo:          emenda['Nº_ADITIVO'] || '',
    termo_cooperacao:   emenda.TERMO_COOPERACAO || '',
    inicio_vigencia:    emenda.INICIO_VIGENCIA || '',
    termino_vigencia:   emenda.TERMINO_VIGENCIA || '',
    origem:             emenda.ORIGEM || '',
    valor_proposta:     emenda.VALOR_DA_PROPOSTA || '',
    contrapartida:      emenda.CONTRAPARTIDA || '',
    natureza_despesa:   emenda.NATUREZA_DESPESA || '',
    area_demandante:    emenda.AREA_DEMANDANTE || '',
  };

  try {
    const res = await api('equipamentos.salvar', payload);
    if (!res.ok) { document.getElementById('alertEquip').textContent=res.erro; document.getElementById('alertEquip').style.display='block'; return; }
    showToast(res.msg,'sucesso');
    document.getElementById('e_descricao').value = '';
    document.getElementById('e_setor').value     = '';
    document.getElementById('e_qtd').value       = '1';
    document.getElementById('e_unit').value      = '';
    document.getElementById('e_total').value     = '';
    carregarEquipamentos();
  } catch(e) {
    document.getElementById('alertEquip').textContent='Erro de conexão.';
    document.getElementById('alertEquip').style.display='block';
  } finally {
    setBtnLoading('btnSalvarEquip','btnSalvarEquipTxt','btnSalvarEquipSpin', false);
  }
}

async function carregarEquipamentos() {
  const conta = CONTA_SELECIONADA || document.getElementById('contaInvestimento').value;
  if (!conta) return;
  try {
    const res = await api('equipamentos.listar', { conta });
    if (!res.ok) return;
    renderEquipamentos(res.dados || []);
  } catch(e) { /* silencioso */ }
}

function renderEquipamentos(lista) {
  const tbody = document.getElementById('tbodyEquip');
  if (!lista.length) {
    tbody.innerHTML = '<tr><td colspan="8" class="empty-state"><p>Nenhum equipamento cadastrado para esta conta</p></td></tr>';
    return;
  }
  tbody.innerHTML = lista.map(e => {
    const total = parseFloat(e.valor_total||0).toLocaleString('pt-BR',{style:'currency',currency:'BRL'});
    const unit  = parseFloat(e.valor_unitario||0).toLocaleString('pt-BR',{style:'currency',currency:'BRL'});
    const data  = e.criado_em ? new Date(e.criado_em).toLocaleDateString('pt-BR') : '—';
    return `<tr>
      <td><strong style="color:var(--cream)">${String(e.conta||'—')}</strong></td>
      <td title="${String(e.descricao_equipamento||'')}">${String(e.descricao_equipamento||'—')}</td>
      <td style="text-align:center">${e.quantidade||0}</td>
      <td>${unit}</td>
      <td style="color:var(--gold);font-weight:500">${total}</td>
      <td>${String(e.setor_destinado||'—')}</td>
      <td style="color:var(--text-dim)">${data}</td>
      <td>
        <button class="btn-icon danger" title="Excluir" onclick="excluirEquipamento('${e.id}')">
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6"/></svg>
        </button>
      </td>
    </tr>`;
  }).join('');
}

async function excluirEquipamento(id) {
  if (!confirm('Excluir este equipamento?')) return;
  try {
    const res = await api('equipamentos.excluir', { id });
    if (!res.ok) { showToast(res.erro,'erro'); return; }
    showToast(res.msg,'sucesso');
    carregarEquipamentos();
  } catch(e) { showToast('Erro ao excluir.','erro'); }
}

// ── HELPERS ──
function setBtnLoading(btnId, txtId, spinId, loading) {
  document.getElementById(btnId).disabled = loading;
  document.getElementById(txtId).style.display = loading ? 'none' : 'inline';
  document.getElementById(spinId).style.display = loading ? 'inline-block' : 'none';
}

let toastTimer;
function showToast(msg, tipo='sucesso') {
  const el = document.getElementById('toast');
  el.className = 'toast ' + tipo;
  el.innerHTML = (tipo==='sucesso'
    ? '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="20 6 9 17 4 12"/></svg>'
    : '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>'
  ) + `<span>${msg}</span>`;
  el.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => el.classList.remove('show'), 3500);
}

async function logout() {
  if (!confirm('Deseja sair?')) return;
  try { await api('logout'); } catch(e) {}
  localStorage.clear();
  window.location.href = 'index.html';
}

document.getElementById('modalEditar').addEventListener('click', e => {
  if (e.target === e.currentTarget) fecharModalEditar();
});
document.addEventListener('keydown', e => {
  if (e.key === 'Escape') fecharModalEditar();
});
</script>
</body>
</html>
