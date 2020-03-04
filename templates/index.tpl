<style>
    {literal}
    .pkpListPanel{
        max-width: 100%;
    }
    table{
        width: 100%;
        border-spacing: 0px;
    }
    td, th, tr{
        border:0;
    }
    td, th{
        padding: 6px 0.85em;
    }
    td+td, th+th{
        border-left:1px solid #cecece;
    }
    tr:nth-child(odd) {
        background-color: #eee;
    }
    th{
        text-align: left;
        background: #eee;
    }
    {/literal}
</style>

<div class="pkpListPanel pkpListPanel--submissions">

    <div class="pkpListPanel__header -pkpClearfix">
    </div>
        <table class="pkpListPanel__items">
            <tr>
                <th>Last activity</th>
                <th>ID</th>
                <th style="width:400px; max-width: 400px;">Name</th>
                <th>Author(s)</th>
                <th>Status</th>
                <th>Last modified</th>
            </tr>
            <tr>
                <td>Centro</td>
                <td>1</td>
                <td>Mexico</td>
                <td>Germany</td>
                <td>Germany</td>
                <td>Germany</td>
            </tr>
            {php}
                $metricsDao = DAORegistry::getDAO('MetricsDAO');
                $result = $metricsDao->retrieve("
                SELECT s.submission_id, ss.setting_value as title, s.status, s.last_modified
                FROM submissions s
                LEFT JOIN submission_settings ss
                ON s.submission_id=ss.submission_id AND ss.locale='vi_VN' AND setting_name='title'
                ");


                $journalDao = DAORegistry::getDAO('JournalDAO');
                $publishedArticleDao = DAORegistry::getDAO('PublishedArticleDAO');

                while (!$result->EOF) {
                $resultRow = $result->GetRowAssoc(false);
                $article = $publishedArticleDao->getById($resultRow['submission_id']);
                $journal = $journalDao->getById($article->getJournalId());
                $articles[$resultRow['submission_id']]['journalPath'] = $journal->getPath();
                $articles[$resultRow['submission_id']]['journalName'] = $journal->getLocalizedName();
                $articles[$resultRow['submission_id']]['articleId'] = $article->getBestArticleId();
                $articles[$resultRow['submission_id']]['articleTitle'] = $article->getLocalizedTitle();


                $html="<tr><td>$article->getDateStatusModified()</td><td>";
                $html.=$resultRow['submission_id'];
                $html.="</td>";
                $html.="<td>".$article->getLocalizedTitle()."</td>";
                $html.="<td>".$article->getAuthorString()."</td>";
                $html.="<td>".($article->getStatus()==3?
                    "<button class='pkpBadge pkpBadge--button pkpBadge--dot pkpBadge--production'>Production</button>":
                    "<button class='pkpBadge pkpBadge--button pkpBadge--dot pkpBadge--submission'>Incomplete</button>") ."</td>";
                $html.="<td>".$resultRow['last_modified']."</td>";
                $html.="</tr>";

                echo $html;

                $result->MoveNext();
                }
                $result->Close();

                $this->assign('arr', $articles);
            {/php}
        </table>
    </div>
</div>